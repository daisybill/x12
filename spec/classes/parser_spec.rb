require 'spec_helper'

describe X12::Parser do
  describe "#initialize" do
    before { allow(File).to receive_message_chain(:open, :read).and_return(sample_xml) }

    it "processes a file" do
      p = X12::Parser.new("blah.xml")
      definition = p.instance_variable_get("@x12_definition")


      expect(definition.class).to eq(X12::XMLDefinitions)
      expect(definition.keys.count).to eq(1)
      expect(definition.include?(X12::Loop)).to be_truthy

      expect(definition[X12::Loop].include?("outer")).to be_truthy
    end
  end


  describe ".sanitized_file_name" do
    it "returns a regular file name" do
      expect(X12::Parser.sanitized_file_name("blah.xml")).to eq("blah.xml")
    end

    it "returns a regular directory name" do
      expect(X12::Parser.sanitized_file_name("/path/to/blah.xml")).to eq("/path/to/blah.xml")
    end

    it "returns a modified DOS file name" do
      expect(X12::Parser.sanitized_file_name("COM1.xml")).to eq("./COM1_.xml")
    end

    it "returns a modified DOS directory name" do
      expect(X12::Parser.sanitized_file_name("/path/to/COM1.xml")).to eq("/path/to/COM1_.xml")
    end
  end
end

