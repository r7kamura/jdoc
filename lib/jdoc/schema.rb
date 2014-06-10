module Jdoc
  class Schema
    DEFAULT_ENDPOINT = "https://api.example.com"

    # Recursively extracts all links in given JSON schema
    # @param json_schema [JsonSchema::Schema]
    # @return [Array] An array of JsonSchema::Schema::Link
    def self.extract_links(json_schema)
      links = json_schema.links.select {|link| link.method && link.href }
      links + json_schema.properties.map {|key, schema| extract_links(schema) }.flatten
    end

    # @param schema [Hash] JSON Schema
    def initialize(schema)
      @json_schema = JsonSchema.parse!(schema).tap(&:expand_references!)
    end

    # @return [Hash{Jdoc::Schema => Array}] Linkes table indexed by their schemata
    def links_indexed_by_resource
      @links_indexed_by_schema ||= links.inject(Hash.new {|h, k| h[k] = [] }) do |result, link|
        result[link.resource] << link
        result
      end
    end

    # @return [String, nil] Title property of this schema
    # @example
    #   schema.title #=> "app"
    def title
      @json_schema.title
    end

    # @return [String]
    # @example
    #   host_with_port #=> "api.example.com"
    #   host_with_port #=> "api.example.com:3000"
    def host_with_port
      if [80, 443].include?(port)
        host
      else
        "#{host}:#{port}"
      end
    end

    private

    # @return [Fixnum] Port number for this API endpoint
    def port
      root_uri.port || 80
    end

    # @return [String] Host name of API, used at dummy Host header
    # @example
    #   schema.host #=> "api.example.com"
    def host
      root_uri.host
    end

    # @return [Array] All links defined in given JSON schema
    # @example
    #   links #=> [#<JsonSchema::Schema::Link>]
    def links
      @links ||= self.class.extract_links(@json_schema).map do |link|
        Link.new(link: link)
      end.sort
    end

    # @return [URI::Generic] Root endpoint for the API
    # @example
    #   root_uri #=> "https://api.example.com"
    def root_uri
      @root_endpoint = begin
        if link = link_for_root_endpoint
          URI(link.href)
        else
          URI(DEFAULT_ENDPOINT)
        end
      end
    end

    # @return [JsonSchema::Schema::Link]
    def link_for_root_endpoint
      @json_schema.links.find do |link|
        link.rel == "self" && link.href
      end
    end
  end
end
