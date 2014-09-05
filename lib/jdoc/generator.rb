module Jdoc
  class Generator
    HTML_TEMPLATE_PATH = File.expand_path("../../../template.html.erb", __FILE__)
    MARKDOWN_TEMPLATE_PATH = File.expand_path("../../../template.md.erb", __FILE__)

    class << self
      # @return [Erubis::Eruby]
      def markdown_renderer
        @markdown_renderer ||= Erubis::Eruby.new(markdown_template)
      end

      # @return [Erubis::Eruby]
      def html_renderer
        @html_renderer ||= Erubis::Eruby.new(html_template)
      end

      def redcarpet
        @redcarpet ||= Redcarpet::Markdown.new(
          Redcarpet::Render::HTML.new(
            filter_html: true,
            hard_wrap: true,
            with_toc_data: true,
          ),
          autolink: true,
          fenced_code_blocks: true,
          no_intra_emphasis: true,
        )
      end

      # @return [String] ERB template
      def markdown_template
        File.read(MARKDOWN_TEMPLATE_PATH)
      end

      # @return [String] ERB template
      def html_template
        File.read(HTML_TEMPLATE_PATH)
      end
    end

    # Utility wrapper for Jdoc::Generator#call
    # @return [String]
    def self.call(*args)
      new(*args).call
    end

    # @param schema [Hash] JSON Schema represented as a Hash
    # @param html [true, false] Pass true to render HTML docs
    def initialize(schema, html: false)
      @raw_schema = schema
      @html = html
    end

    # Generates Markdown or HTML documentation from JSON schema
    # @note Add some fix to adapt to GitHub anchor style
    # @return [String]
    def call
      result = self.class.markdown_renderer.result(schema: schema)
      if @html
        result = self.class.html_renderer.result(body: self.class.redcarpet.render(result))
        result.gsub(/id="(.+)"/) {|text| text.tr("/:", "") }
      else
        result
      end
    rescue Jdoc::Link::ExampleNotFound => exception
      abort("Error: #{exception.to_s}")
    end

    private

    # @return [Jdoc::Schema]
    # @raise [JsonSchema::SchemaError] Raises if given invalid JSON Schema
    def schema
      @schema ||= Jdoc::Schema.new(@raw_schema)
    end
  end
end
