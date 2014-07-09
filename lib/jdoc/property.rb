module Jdoc
  class Property
    attr_reader :name

    # @param name [String]
    # @param schema [JsonSchema::Schema]
    def initialize(name: nil, schema: nil, indent: 0)
      @name = name
      @schema = schema
      @indent = indent
    end

    # @return [String] Markdown representation
    def to_s
      str = ""
      str << "* #{name}\n"
      str << " * #{description}\n" if description
      options.each do |key, value|
        str << " * #{key}: #{value}\n"
      end
      properties.each do |property|
        str << property.to_s
      end
      str.indent(@indent)
    end

    private

    # @return [Hash] Key-Value pair of metadata of this property
    def options
      {
        Example: example,
        Type: type,
        Format: format,
        Patern: pattern,
        ReadOnly: read_only,
      }.reject {|key, value| value.nil? }
    end

    # @return [String, nil] Description text, defined in description property
    def description
      @schema.description
    end

    # @return [String, nil] Example value, defined in example property
    def example
      if @schema.data.has_key?("example")
        %<`#{@schema.data["example"].inspect}`>
      end
    end

    # @return [String, nil] Pattern constraint, defined in pattern property
    def pattern
      if str = @schema.pattern
        "`#{str}`"
      end
    end

    # @return [Stirng, nil] Format constraint, defined in format property
    def format
      @schema.format
    end

    # @return [true, nil] True if readOnly property is defined and it's true
    def read_only
      true if @schema.read_only == true
    end

    # @return [String, nil] Possible types defined in type property
    def type
      unless @schema.type.empty?
        @schema.type.join(", ")
      end
    end

    # @return [Array<Jdoc::Schema>]
    def properties
      @properties ||= begin
        if has_properties?
          @schema.properties.map do |name, property|
            Property.new(name: name, schema: property, indent: @indent + 1)
          end
        else
          []
        end
      end
    end

    # @return [true, false] True if this property has any sub properties
    def has_properties?
      !!@schema.properties
    end
  end
end
