module Jdoc
  class Link
    # @param link [JsonSchema::Schema::Link]
    def initialize(link)
      @raw_link = link
    end

    # @return [String] method + path
    # @example
    #   link.endpoint #=> "GET /apps"
    def endpoint
      "#{method} #{path}"
    end

    # Responds to .sort method
    # @return [Fixnum]
    def <=>(schema)
      sort_key <=> schema.sort_key
    end

    # For #<=> method
    # @return [String]
    def sort_key
      "#{path} #{method_order_score}"
    end

    # @return [String] Description for this endpoint, defined in description property
    # @example
    #   link.description #=> "List existing apps."
    def description
      @raw_link.description
    end

    # @return [String] Href anchor for putting link in ToC
    # @example
    #   link.anchor #=> "#get-apps"
    def anchor
      "#" + endpoint.gsub(" ", "-").gsub(/[:\/]/, "").downcase
    end

    # @return [String] Markdown styled link text for endpoint
    # @example
    #   link.hyperlink #=> "[GET /apps](#get-apps)"
    def hyperlink
      "[#{endpoint}](#{anchor})"
    end

    # @return [String] Upper cased HTTP request method name
    # @example
    #   link.method #=> "GET"
    def method
      @method ||= @raw_link.method.to_s.upcase
    end

    # @return [String] Request path name, defined at href property
    # @note URI Template is replaced with placeholder
    # @example
    #   link.path #=> "GET /apps/:id"
    def path
      @path ||= @raw_link.href.gsub(/{(.+?)}/) do
        ":" + CGI.unescape($1).gsub(/[()\s]/, "").split("/").last
      end
    end

    # @returns [String] Path with embedded example variable
    # @raise [Rack::Spec::Mock::ExampleNotFound]
    # @example
    #   link.example_path #=> "GET /apps/1"
    def example_path
      @example_path ||= @raw_link.href.gsub(/{\((.+?)\)}/) do
        pointer = CGI.unescape($1)
        value = JsonPointer.evaluate(root_schema.data, pointer)
        if value && value["example"]
          value["example"]
        else
          raise ExampleNotFound, "No example found for #{pointer}"
        end
      end
    end

    # @return [String] request content type
    # @note default value is "application/json"
    def content_type
      type = @raw_link.enc_type
      type += "; #{Request::Multipart.boundary}" if content_type_multipart?
      type
    end

    # Adds query string if a link has a schema property and method is GET
    # @return [String, nil] A query string prefixed with `?` only to GET request
    # @example
    #   link.query_string #=> "?type=Recipe"
    def query_string
      if method == "GET" && !request_parameters.empty?
        "?#{request_parameters.to_query}"
      end
    end

    # @return [String, nil] Example request body in JSON format
    def request_body
      body = case
      when content_type_multipart?
        request_body_in_multipart
      when content_type_json?
        request_body_in_json
      else
        ""
      end
      body + "\n"
    end

    # @return [true, false] True if encType of request is multipart/form-data
    def content_type_multipart?
      Rack::Mime.match?(@raw_link.enc_type, "multipart/form-data")
    end

    # @return [true, false] True if encType of request is multipart/form-data
    def content_type_json?
      Rack::Mime.match?(@raw_link.enc_type, "application/json")
    end

    # @return [Hash] Example request parameters for this endpoint
    def request_parameters
      @request_parameters ||= begin
        if request_schema
          RequestGenerator.call(request_schema.properties)
        else
          {}
        end
      end
    end

    # @return [Array<Jdoc::Property>] Properties defined in this link's schema property.
    def request_properties
      @request_properties ||= begin
        if request_schema
          request_schema.properties.map do |name, schema|
            Property.new(name: name, schema: schema)
          end
        else
          []
        end
      end
    end

    # @return [true, false] True if this endpoint must have request body
    def has_request_body?
      ["PATCH", "POST", "PUT"].include?(method) && !request_parameters.empty?
    end

    # We have a policy that we should not return response body to PUT and DELETE requests.
    # @return [true, false] True if this endpoint must have response body
    def has_response_body?
      @raw_link.media_type != "null"
    end

    # @return [String] JSON response body generated from example properties
    def response_body
      object = has_list_data? ? [response_hash] : response_hash
      JSON.pretty_generate(object)
    end

    # @return [Fixnum] Preferred respone status code for this endpoint
    def response_status
      case method
      when "POST"
        201
      when "PUT", "DELETE"
        204
      else
        200
      end
    end

    # @return [JsonSchema::Schema] Response schema for this link
    def response_schema
      @raw_link.target_schema || @raw_link.parent
    end

    # @return [JsonSchema::Schema] Request schema for this link
    def request_schema
      @raw_link.schema
    end

    # @return [Json::Link::Resource]
    # @note Resource means each property of top-level properties in this context
    def resource
      @resource ||= Resource.new(response_schema)
    end

    private

    # @return [JsonSchema::Schema] Root schema object this link is associated to
    def root_schema
      @root ||= begin
        schema = @raw_link
        while schema.parent
          schema = schema.parent
        end
        schema
      end
    end

    # @return [true, false] True if response is intended to be list data
    def has_list_data?
      @raw_link.rel == "instances"
    end

    # @return [Hash]
    # @raise [Rack::Spec::Mock::ExampleNotFound]
    def response_hash
      ResponseGenerator.call(response_schema.properties)
    end

    # @return [String, nil] Example request body in Multipart
    def request_body_in_multipart
      Request::Multipart.new(request_parameters).dump
    end

    # @return [String, nil] Example request body in JSON format
    def request_body_in_json
      JSON.pretty_generate(request_parameters)
    end

    # @return [Fixnum] Order score, used to sort links by preferred method order
    def method_order_score
      case method
      when "GET"
        1
      when "POST"
        2
      when "PUT"
        3
      when "PATCH"
        4
      when "DELETE"
        5
      else
        6
      end
    end

    class RequestGenerator
      # Generates example request body from given schema
      # @param properties [Hash]
      # @note Not includes properties that have readOnly property
      # @return [Hash]
      # @example
      #   Jdoc::Link::RequestGenerator(schema.properties) #=> { "name" => "example", "description" => "foo bar." }
      def self.call(properties)
        ResponseGenerator.call(properties.reject {|key, value| value.data["readOnly"] })
      end
    end

    class ResponseGenerator
      # Generates example response Hash from given schema
      # @param properties [Hash]
      # @return [Hash]
      # @example
      #   Jdoc::Link::ResponseGenerator(properties) #=> { "id" => 1, "name" => "example" }
      def self.call(properties)
        properties.inject({}) do |result, (key, value)|
          result.merge(
            key => case
            when !value.properties.empty?
              call(value.properties)
            when !value.data["example"].nil?
              value.data["example"]
            when value.type.include?("null")
              nil
            when value.type.include?("array")
              if example = value.items.data["example"]
                [example]
              else
                [call(value.items.properties)]
              end
            else
              raise ExampleNotFound, "No example found for #{value.pointer}"
            end
          )
        end
      end
    end

    class ExampleNotFound < StandardError
    end
  end
end
