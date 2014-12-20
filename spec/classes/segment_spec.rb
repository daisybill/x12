require 'spec_helper'

describe X12::Segment do

  let(:f_constant) { X12::Field.new("test1", "\"997\"", false, 3, 3, nil) }
  let(:field_1) { X12::Field.new("test2", "string", false, 3, 3, nil) }
  let(:field_2) { X12::Field.new("test3", "string", false, 3, 3, nil) }

  describe "a segment with a constant" do
    subject { X12::Segment.new("MYSEG", [f_constant, field_1], 1..999) }

    describe "#parse" do
      it "grabs the whole line when that's all there is" do
        expect(subject.parse("MYSEG*997*blow~")).to eq("")
        expect(subject.parsed_str).to eq("MYSEG*997*blow~")
      end

      it "grabs just the segment from a larger string" do
        expect(subject.parse("MYSEG*997*blow~extra*1234~")).to eq("extra*1234~")
        expect(subject.parsed_str).to eq("MYSEG*997*blow~")
      end

      it "returns nil if the segment wasn't found" do
        expect(subject.parse("extra*1234~")).to be_nil
        expect(subject.parsed_str).to be_nil
      end
    end

    describe "#regexp" do
      it "returns a correct regular expression" do
        expect(subject.regexp).to eq(Regexp.new("^MYSEG\\*(997\\*?)?([^\\*~]*\\*?)?~"))
      end
    end
  end


  describe "a segment with no constants" do
    subject { X12::Segment.new("MYSEG", [field_1, field_2], 1..999) }

    describe "#parse" do
      it "grabs the whole line when that's all there is" do
        expect(subject.parse("MYSEG*joe*blow~")).to eq("")
        expect(subject.parsed_str).to eq("MYSEG*joe*blow~")
      end

      it "grabs just the segment from a larger string" do
        expect(subject.parse("MYSEG*joe*blow~extra*1234~")).to eq("extra*1234~")
        expect(subject.parsed_str).to eq("MYSEG*joe*blow~")
      end

      it "returns nil if the segment wasn't found" do
        expect(subject.parse("extra*1234~")).to be_nil
        expect(subject.parsed_str).to be_nil
      end
    end

    describe "#render" do
    end

    describe "#regexp" do
      it "returns a regular expression to grab the whole line" do
        expect(subject.regexp).to eq(Regexp.new("^MYSEG\\*[^~]*~"))
      end
    end

    describe "#find_field" do
      it "finds a field that is there" do
        expect(subject.find_field("test2")).to eq(field_1)
      end

      it "doesn't find a field that isn't there" do
        expect(subject.find_field("missing").class).to eq(X12::Empty)
      end
    end
  end
end

