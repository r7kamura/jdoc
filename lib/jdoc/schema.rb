module Jdoc
  class Schema
    # @param schema [Hash] JSON Schema
    def initialize(schema: nil)
      @raw_schema = schema
    end

    # @return [Array<Jdoc::Schema::Link>] Sorted links
    def links
      @links ||= rack_schema.links.map {|link| Link.new(link: link) }.sort
    end

    # @return [String, nil] Title property of this schema
    def title
      @raw_schema["title"]
    end

    private

    # @return [Rack::Spec::Schema]
    def rack_schema
      @rack_schema ||= Rack::Spec::Schema.new(@raw_schema)
    end
  end
end
