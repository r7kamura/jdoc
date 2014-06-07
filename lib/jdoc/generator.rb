module Jdoc
  class Generator
    TEMPLATE_PATH = File.expand_path("../../../template.md.erb", __FILE__)

    # Utility wrapper for Jdoc::Generator#call
    # @return [String]
    def self.call(*args)
      new(*args).call
    end

    # @param schema [Hash] JSON Schema represented as a Hash
    def initialize(schema: nil)
      @raw_schema = schema
    end

    # Generates documentation in Markdown format from JSON schema
    # @return [String] Text of generated markdown document
    def call
      eruby.result(context)
    end

    private

    # @return [Hash] Context object used as a set of local variables for rendering template
    def context
      { schema: schema }
    end

    # @return [JsonSchema::Schema]
    # @raise [JsonSchema::SchemaError]
    def schema
      @schema ||= JsonSchema.parse!(@raw_schema).tap(&:expand_references!)
    end

    # @return [Erubis::Eruby]
    def eruby
      Erubis::Eruby.new(template)
    end

    # @return [String] ERB template
    def template
      File.read(TEMPLATE_PATH)
    end
  end
end
