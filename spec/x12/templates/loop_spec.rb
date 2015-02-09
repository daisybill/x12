require 'spec_helper'

describe X12::Templates::Loop do
  let(:xml) do
    str = File.open("#{X12::ROOT}/spec/misc/loops.xml", 'r').read
    Nokogiri.XML(str) { |c| c.noblanks }.root
  end
  let(:loop) { X12::Templates::Loop.from_xml(node) }

  context 'when only name attribute present' do
    let(:node) { xml.children[0] }

    it { expect(loop.name).to eq('first') }
    it { expect(loop).not_to be_required }
    it { expect(loop.range).to eq(-Float::INFINITY..Float::INFINITY) }
  end

  context 'when required, min and max attributes are present' do
    let(:node) { xml.children[1] }

    it { expect(loop.name).to eq('second') }
    it { expect(loop).to be_required }
    it { expect(loop.range).to eq(2..10) }
  end
end
