require 'spec_helper'

describe X12::Templates::Segment do
  let(:xml) do
    str = File.open("#{X12::ROOT}/spec/misc/segments.xml", 'r').read
    Nokogiri.XML(str) { |c| c.noblanks }.root
  end
  let(:segment) { X12::Templates::Segment.from_xml(node) }

  context 'when there is only name' do
    let(:node) { xml.children[0] }

    it { expect(segment.name).to eq('first') }
    it { expect(segment).not_to be_required }
  end

  context 'when required attribute is present' do
    let(:node) { xml.children[1] }

    it { expect(segment.name).to eq('second') }
    it { expect(segment).to be_required }
  end

  context 'when min and max attributes are present' do
    let(:node) { xml.children[2] }

    it { expect(segment.name).to eq('third') }
    it { expect(segment).not_to be_required }
    it { expect(segment.range).to eq(13..666) }
  end
end
