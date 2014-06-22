module Jdoc
  class Resource
    attr_reader :schema

    class TitleNotFound < StandardError
    end

    # @param schema [JsonSchema::Schema]
    def initialize(schema)
      if schema.title.nil?
        raise TitleNotFound
      end

      @schema = schema
    end

    # @return [String] Description for this schema, defined in description property
    # @example
    #   resource.description #=> "An app is a program to be deployed."
    def description
      @schema.description
    end

    # @return [String] Href anchor for putting link in ToC
    # @example
    #   resource.anchor #=> "#app"
    def anchor
      "#" + title.gsub(" ", "-").gsub(/[:\/]/, "").downcase
    end

    # @return [String] Markdown styled link text for this resource
    # @example
    #   resource.hyperlink #=> "[App](#apps)"
    def hyperlink
      "[#{title}](#{anchor})"
    end

    # @return [String] Title defined in title property
    # @example
    #   resource.title #=> "App"
    def title
      @schema.title
    end

    # @return [Array<Jdoc::Property>]
    def properties
      @schema.properties.map do |name, schema|
        Property.new(name: name, schema: schema)
      end
    end

    # Defined to change uniqueness in Hash key
    def hash
      @schema.title.hash
    end

    # Defined to change uniqueness in Hash key
    def eql?(other)
      @schema.title == other.title
    end

    def <=>(other)
      @schema.title <=> other.title
    end

    def links
      @links ||= @schema.links.map do |link|
        if link.method && link.href
          Link.new(link)
        end
      end.compact
    end
  end
end
