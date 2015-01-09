require 'spec_helper'

describe X12::Templates::Field do
  let(:xml) do
    str = File.open("#{X12::ROOT}/spec/misc/fields.xml", 'r').read
    Nokogiri.XML(str) { |c| c.noblanks }.root
  end
  let(:field) { X12::Templates::Field.from_xml(node) }

  context 'when validation and required attributes omitted' do
    let(:node) { xml.children[0] }

    it { expect(field.name).to eq('first') }
    it { expect(field).to_not be_validation }
    it { expect(field).to_not be_required }
    it { expect(field.range).to eq 1..10 }
  end

  context 'when validation and required attributes are false' do
    let(:node) { xml.children[1] }

    it { expect(field.name).to eq('second') }
    it { expect(field).to_not be_validation }
    it { expect(field).to_not be_required }
    it { expect(field.range).to eq 2..10 }
  end

  context 'when validation and required attributes are true' do
    let(:node) { xml.children[2] }

    it { expect(field.name).to eq('third') }
    it { expect(field).to be_validation }
    it { expect(field).to be_required }
    it { expect(field.range).to eq 3..3 }
  end

  context 'when min greater than max' do
    let(:node) { xml.children[3] }

    it { expect { field }.to raise_error ArgumentError }
  end
end
