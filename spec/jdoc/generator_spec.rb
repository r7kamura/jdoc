require "spec_helper"
require "active_support/core_ext/string/strip"
require "yaml"

describe Jdoc::Generator do
  describe ".call" do
    subject do
      described_class.call(schema)
    end

    let(:schema) do
      YAML.load_file(schema_path)
    end

    let(:schema_path) do
      File.expand_path("../../fixtures/schema.yml", __FILE__)
    end

    it "returns a String of API documentation in Markdown from given JSON Schema" do
      should == <<-EOS.strip_heredoc
        # API Documentation
        * GET /apps
        * POST /apps
        * GET /apps/:id
        * PATCH /apps/:id
        * DELETE /apps/:id
        * GET /recipes

        ## GET /apps
        List existing apps.

        ## POST /apps
        Create a new app.

        ## GET /apps/:id
        Info for existing app.

        ## PATCH /apps/:id
        Update an existing app.

        ## DELETE /apps/:id
        Delete an existing app.

        ## GET /recipes
        List recipes.

      EOS
    end
  end
end
