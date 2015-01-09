require 'spec_helper'

describe X12::Attributes do
  let(:xml) do
    str = File.open("#{X12::ROOT}/spec/misc/attributes.xml", 'r').read
    Nokogiri.XML(str) { |c| c.noblanks }.root
  end

  context '.string' do
    let(:node) { xml.children[0] }

    it { expect(X12::Attributes.string(node, :name)).to eq('string') }
    it { expect(X12::Attributes.string(node, :comment)).to eq('Lorem Ipsum Dolor') }
    it { expect(X12::Attributes.string(node, :empty)).to be_empty }
    it { expect(X12::Attributes.string(node, :nil)).to be_nil }
  end

  context '.int' do
    let(:node) { xml.children[1] }

    it { expect(X12::Attributes.string(node, :name)).to eq('int') }
    it { expect(X12::Attributes.int(node, :zero)).to be_zero }
    it { expect(X12::Attributes.int(node, :devil)).to eq(13666) }
    it { expect(X12::Attributes.int(node, :empty)).to eq 0 }
    it { expect(X12::Attributes.int(node, :nil)).to be_nil }
    it { expect(X12::Attributes.int(node, :inf)).to eq(Float::INFINITY) }
  end

  context '.boolean' do
    context 'when true' do
      let(:node) { xml.children[2] }

      it { expect(X12::Attributes.string(node, :name)).to eq('true boolean') }
      it { expect(X12::Attributes.boolean(node, :y)).to    be_truthy }
      it { expect(X12::Attributes.boolean(node, :yes)).to  be_truthy }
      it { expect(X12::Attributes.boolean(node, :t)).to    be_truthy }
      it { expect(X12::Attributes.boolean(node, :true)).to be_truthy }
      it { expect(X12::Attributes.boolean(node, :one)).to  be_truthy }
    end

    context 'when false' do
      let(:node) { xml.children[3] }

      it { expect(X12::Attributes.string(node, :name)).to eq('false boolean') }
      it { expect(X12::Attributes.boolean(node, :devil)).to be_nil }
      it { expect(X12::Attributes.boolean(node, :empty)).to be_falsey }
      it { expect(X12::Attributes.boolean(node, :nil)).to   be_falsey }
      it { expect(X12::Attributes.boolean(node, :n)).to     be_falsey }
      it { expect(X12::Attributes.boolean(node, :no)).to    be_falsey }
      it { expect(X12::Attributes.boolean(node, :f)).to     be_falsey }
      it { expect(X12::Attributes.boolean(node, :false)).to be_falsey }
      it { expect(X12::Attributes.boolean(node, :zero)).to  be_falsey }
    end
  end

  context '.range' do
    let(:node) { xml.children[4] }

    it { expect(X12::Attributes.string(node, :name)).to eq('range') }
    it { expect(X12::Attributes.range(node, :zero, :devil)).to eq(0..13666) }
    it { expect(X12::Attributes.range(node, :devil, :devil)).to eq(13666..13666) }
    it { expect{ X12::Attributes.range(node, :devil, :zero) }.to raise_error ArgumentError }
    it { expect(X12::Attributes.range(node, :empty, :empty)).to eq(0..0) }
    it { expect(X12::Attributes.range(node, :nil, :nil)).to eq(-Float::INFINITY..Float::INFINITY) }
  end
end
