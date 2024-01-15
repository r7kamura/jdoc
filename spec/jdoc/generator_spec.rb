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
      should == File.read(File.expand_path("../../../example-api-documentation.md", __FILE__))
    end

    context "with html: true" do
      subject do
        described_class.call(schema, html: true)
      end

      it "returns a String of API documentation in HTML from given JSON Schema" do
        should == File.read(File.expand_path("../../../example-api-documentation.html", __FILE__))
      end
    end
  end
end
