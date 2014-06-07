require "spec_helper"
require "yaml"

describe Jdoc::Generator do
  describe ".call" do
    subject do
      described_class.call(schema: schema)
    end

    let(:schema) do
      YAML.load_file(schema_path)
    end

    let(:schema_path) do
      File.expand_path("../../fixtures/schema.yml", __FILE__)
    end

    it "returns a String of API documentation in Markdown from given JSON Schema" do
      should be_a String
    end
  end
end
