require 'spec_helper'

describe X12::NewSegment do
  let(:segment) { X12::NewSegment.new str, '*' }

  context 'when all fields are present' do
    let(:str) { 'SEG*string*13666*10/01/15' }

    it { expect(segment.name).to eq('SEG') }
    it { expect(segment.size).to eq(3) }
    it { expect(segment.fields[0]).to eq('string') }
    it { expect(segment.fields[1]).to eq('13666') }
    it { expect(segment.fields[2]).to eq('10/01/15') }
    it { expect(segment.fields[3]).to be_nil }
  end

  context 'when contains empty fields' do
    let(:str) { 'SEG**13666*10/01/15' }

    it { expect(segment.name).to eq('SEG') }
    it { expect(segment.size).to eq(3) }
    it { expect(segment.fields[0]).to be_empty }
    it { expect(segment.fields[1]).to eq('13666') }
    it { expect(segment.fields[2]).to eq('10/01/15') }
    it { expect(segment.fields[3]).to be_nil }
  end

  context 'when name empty' do
    let(:str) { '***' }

    it { expect { segment }.to raise_error }
  end
end
