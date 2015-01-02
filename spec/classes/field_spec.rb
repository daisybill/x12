require 'spec_helper'

describe X12::Structures::Field do
  let(:field_sep) { "*" }
  let(:segment_sep) { "~" }

  describe "A definition with a constant type" do
    # Field TransactionSetIdentifierCode|"997"|false|3-3|T143 <>
    subject { X12::Structures::Field.new("test", "\"997\"", false, 3, 3, nil) }

    it "should render properly" do
      expect(subject.render).to eq("997")
    end

    it "should return a regular expression" do
      expect(subject.simple_regexp(field_sep, segment_sep)).to eq("997")
    end
  end

  describe "A string with no validation" do
    # Field TransactionSetControlNumber|string|false|4-9| <>
    subject { X12::Structures::Field.new("test", "string", false, 4, 9, nil) }

    it "should render properly" do
      subject.content = "blah"

      expect(subject.render).to eq("blah")
      expect(subject.has_content?).to be_truthy
    end

    it "should render properly when there is no content" do
      expect(subject.render).to eq("")
      expect(subject.has_content?).to be_falsey
    end

    it "should return a regular expression" do
      expect(subject.simple_regexp(field_sep, segment_sep)).to eq("[^\\*~]*")
    end
  end

  describe "A string with a validation" do
    # Field TransactionSetIdentifierCode|string|true|3-3|T143 <>
    # Hmm, it doesn't actually touch that validation!
    subject { X12::Structures::Field.new("test", "blah", true, 3, 3, "T143") }

    it "should render properly" do
      subject.content = "997"

      expect(subject.render).to eq("997")
      expect(subject.has_content?).to be_truthy
    end

    it "should render properly when there is no content" do
      expect(subject.render).to eq("")
      expect(subject.has_content?).to be_falsey
    end
  end
end

