module Jdoc
  class Generator
    # Utility wrapper for Jdoc::Generator#call
    # @return [String]
    def self.call(*args)
      new(*args).call
    end

    # @param schema [Hash] JSON Schema represented as a Hash
    def initialize(schema: nil)
      @schema = schema
    end

    # Generates documentation in Markdown format from JSON schema
    # @return [String] Text of generated markdown document
    def call
      "TODO"
    end
  end
end
