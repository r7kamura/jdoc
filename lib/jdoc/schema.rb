module Jdoc
  class Schema
    # @param schema [Hash] JSON Schema
    def initialize(schema: nil)
      @raw_schema = schema
    end

    # @return [Hash{Jdoc::Schema => Array}] Linkes table indexed by their schemata
    def links_indexed_by_schema
      @links_indexed_by_schema ||= links.inject(Hash.new {|h, k| h[k] = [] }) do |result, link|
        result[link.schema] << link
        result
      end
    end

    # @return [String, nil] Title property of this schema
    # @example
    #   schema.title #=> "app"
    def title
      @raw_schema["title"]
    end

    private

    # @return [Array<Jdoc::Schema::Link>] Sorted links
    def links
      rack_schema.links.map {|link| Link.new(link: link) }.sort
    end

    # @return [Rack::Spec::Schema]
    def rack_schema
      @rack_schema ||= Rack::Spec::Schema.new(@raw_schema)
    end
  end
end
