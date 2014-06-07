module Jdoc
  class Schema
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

    private

    # @return [Array] All links defined in given JSON schema
    # @example
    #   schema.links #=> [#<JsonSchema::Schema::Link>]
    def links
      @links ||= self.class.extract_links(@json_schema).map do |link|
        Link.new(link: link)
      end.sort
    end
  end
end
