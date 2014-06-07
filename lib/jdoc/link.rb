module Jdoc
  class Link
    # @param link [JsonSchema::Schema::Link]
    def initialize(link: nil)
      @raw_link = link
    end

    # @return [String] method + path
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

    private

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

    # @return [String] Upper cased HTTP request method name
    # @example
    #   link.method #=> "GET"
    def method
      @raw_link.method.to_s.upcase
    end

    # @return [String] Request path name, defined at href property
    # @note URI Template is replaced with placeholder
    # @example
    #   link.path #=> "GET /apps/:id"
    def path
      @raw_link.href.gsub(/{(.+)}/) do |matched|
        ":" + CGI.unescape($1).gsub(/[()]/, "").split("/").last
      end
    end
  end
end
