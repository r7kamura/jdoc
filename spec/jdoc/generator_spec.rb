require "spec_helper"

describe Jdoc::Generator do
  describe ".call" do
    subject do
      described_class.call(schema)
    end

    let(:schema) do
      {}
    end

    it "returns a String of API documentation in Markdown from given JSON Schema" do
      should be_a String
    end
  end
end
