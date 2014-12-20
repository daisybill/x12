require 'spec_helper'

describe "a mixed template" do
  let(:parser) { X12::Parser.new('blah') }
  before { allow(File).to receive_message_chain(:open, :read).and_return(mixed_xml) }

  describe "a document with both types" do
    subject { parser.parse("message", document_a) }

    it "pulls out the header" do
      expect(subject.ISA.to_s).to eq("ISA*00~")
    end

    it "pulls out the footer" do
      expect(subject.IEA.to_s).to eq("IEA*2~")
    end

    it "pulls out the first group" do
      expect(subject.GS[0].Start).to eq("Number1")
      expect(subject.FG[0].GS.to_s).to eq("GS*Number1~")

      expect(subject.FG[0].GE.to_s).to eq("GE*Number1~")
    end

    it "pulls out the 824 within the first group" do
      expect(subject.FG[0].ST.A).to eq("824")
      expect(subject.FG[0].ST.B).to eq("1")

      expect(subject.FG.to_s).to eq("GS*Number1~ST*824*1~FOO*hello~SE*Test~GE*Number1~")
    end

    it "pulls out the 997 within the second group" do
      expect(subject.FG2.ST.A).to eq("997")
      expect(subject.FG2[0].ST.B).to eq("2")
      expect(subject.FG2.GS.to_s).to eq("GS*Number2~")

      expect(subject.FG2.to_s).to eq("GS*Number2~ST*997*2~BAR*Doc2SE*2~GE*Number1~")
    end
  end

  def document_a
'ISA*00~
GS*Number1~
ST*824*1~
FOO*hello~
SE*Test~
GE*Number1~
GS*Number2~
ST*997*2~
BAR*Doc2
SE*2~
GE*Number1~
IEA*2~'.gsub(/\n/,'')
  end

  def mixed_xml
'<Loop name="message" min="1" max="1">
  <Segment name="ISA" min="1" max="1">
    <Field name="Something" />
  </Segment>
  <Loop name="FG" min="1" max="inf">
    <Segment name="GS" min="1" max="1">
      <Field name="Start" />
    </Segment>
    <Loop name="document_a" comment="xxx">
      <Segment name="ST"  max="1">
        <Field name="A" const="824" min="3" max="3"/>
        <Field name="B" min="4" max="9"/>
      </Segment>
      <Segment name="FOO" max="1">
        <Field name="Test" />
      </Segment>
      <Segment name="SE" >
        <Field name="Tests" />
      </Segment>
    </Loop>
    <Segment name="GE" min="1" max="1">
      <Field name="End" />
    </Segment>
  </Loop>
  <Loop name="FG2" min="1" max="inf">
    <Segment name="GS" min="1" max="1">
      <Field name="Start" />
    </Segment>
    <Loop name="document_b" comment="xxx">
      <Segment name="ST"  max="1">
        <Field name="A" const="997" min="3" max="3"/>
        <Field name="B" min="4" max="9"/>
      </Segment>
      <Segment name="BAR" max="1">
        <Field name="Blah" />
      </Segment>
      <Segment name="SE" >
        <Field name="Test" />
      </Segment>
    </Loop>
    <Segment name="GE" min="1" max="1">
      <Field name="End" />
    </Segment>
  </Loop>

  <Segment name="IEA" min="1" max="1">
    <Field name="Something" />
  </Segment>
</Loop>
'
  end
end

