require 'spec_helper'

describe "a mixed template" do
  let(:parser) { X12::Parser.new("#{X12::ROOT}/spec/misc/mixed.xml") }

  describe "a document with both types" do
    subject { parser.parse("mixed", document_a) }

    it "pulls out the header" do
      expect(subject.ISA.Something).to eq("00")
    end

    it "pulls out the footer" do
      expect(subject.IEA.Something).to eq("2")
    end

    it "pulls out the first group" do
      # expect(subject.GS[0].Start).to eq("Number1")
      expect(subject.FG[0].GS.Start).to eq("Number1")

      expect(subject.FG[0].GE.End).to eq("Number1")
    end

    it "pulls out the 824 within the first group" do
      expect(subject.FG[0].document_a[0].ST.A).to eq("824")
      expect(subject.FG[0].document_a[0].ST.B).to eq("1")

      # expect(subject.FG.to_s).to eq("GS*Number1~ST*824*1~FOO*hello~SE*Test~GE*Number1~")
    end

    it "pulls out the 997 within the second group" do
      require 'pry'
      binding.pry
      expect(subject.FG2[0].GS.Start).to eq("Number2")
      expect(subject.FG2[0].document_b[0].ST.A).to eq("997")
      expect(subject.FG2[0].document_b[0].ST.B).to eq("2")

      # expect(subject.FG2.to_s).to eq("GS*Number2~ST*997*2~BAR*Doc2SE*2~GE*Number1~")
    end
  end

  def document_a
'ISA*00~
GS*Number1~
ST*824*1~
FOO*hello~
SE*Test~
GE*Number1~
GS*Number1.5~
ST*824*1.5~
BAR*hello1.5~
SE*Test1.5~
GE*Number1.5~
GS*Number2~
ST*997*2~
BAR*Doc2
SE*2~
GE*Number1~
IEA*2~'.gsub(/\n/,'')
  end
end

