module Jdoc
  class Generator
    DEFAULT_HTML_TEMPLATE_PATH = File.expand_path("../../../template.html.erb", __FILE__)
    DEFAULT_MARKDOWN_TEMPLATE_PATH = File.expand_path("../../../template.md.erb", __FILE__)

    # Utility wrapper for Jdoc::Generator#call
    # @return [String]
    def self.call(*args, **kwargs)
      new(*args, **kwargs).call
    end

    # @param schema [Hash] JSON Schema represented as a Hash
    # @param html [true, false] Pass true to render HTML docs
    # @param html_template_path [String] Path to ERB template to render HTML
    # @param Markdown_template_path [String] Path to ERB template to render Markdown
    def initialize(schema, html: false, html_template_path: nil, markdown_template_path: nil)
      @raw_schema = schema
      @html = html
      @html_template_path = html_template_path
      @markdown_template_path = markdown_template_path
    end

    # Generates Markdown or HTML documentation from JSON schema
    # @note Add some fix to adapt to GitHub anchor style
    # @return [String] Generated text
    def call
      markdown = markdown_renderer.result(schema: schema)
      if @html
        html = markdown_parser.render(markdown)
        html =  html_renderer.result(body: html)
        html.gsub(/id="(.+)"/) {|text| text.tr("/:", "") }
      else
        markdown
      end
    rescue Jdoc::Link::ExampleNotFound => exception
      abort("Error: #{exception.to_s}")
    end

    private

    # @return [Erubis::Eruby] Renderer to render HTML that takes HTML string
    def html_renderer
      Erubis::Eruby.new(html_template)
    end

    # @returns [String] Path to ERB template to render HTML
    def html_template_path
      @html_template_path || DEFAULT_HTML_TEMPLATE_PATH
    end

    def html_template
      File.read(html_template_path)
    end

    # @return [Redcarpet::Markdown] Markdown parser to convert Markdown into HTML
    def markdown_parser
      Redcarpet::Markdown.new(
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

    # @return [Erubis::Eruby] Renderer to render Markdown that takes schema data
    def markdown_renderer
      Erubis::Eruby.new(markdown_template)
    end

    # @return [String] Content of specified Markdown template
    def markdown_template
      File.read(markdown_template_path)
    end

    # @return [String] Path to ERB template to render Markdown
    def markdown_template_path
      @markdown_template_path || DEFAULT_MARKDOWN_TEMPLATE_PATH
    end

    # @return [Jdoc::Schema]
    # @raise [JsonSchema::SchemaError] Raises if given invalid JSON Schema
    def schema
      Jdoc::Schema.new(@raw_schema)
    end
  end
end
