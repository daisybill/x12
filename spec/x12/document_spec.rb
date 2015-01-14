require 'spec_helper'

describe X12::Document do
  let(:document) { X12::Document.new(content, { segment: '~', field: '*' }) }
  let(:content) { 'ST*997*13666~AK3*13*666~' }

  context '#size' do
    it { expect(document.size).to eq(2) }
    it 'after fetch' do
      document.fetch
      expect(document.size).to eq(1)
    end
    it 'after next' do
      document.next
      expect(document.size).to eq(1)
    end
  end

  context '#current' do
    let(:current) { document.current }

    it { expect(current.name).to eq('ST') }
    it { expect(current.fields[0]).to eq('997') }
    it { expect(current.fields[1]).to eq('13666') }
  end

  context '#next' do
    let(:nekst) { document.next }

    it { expect(nekst.name).to eq('AK3') }
    it { expect(nekst.fields[0]).to eq('13') }
    it { expect(nekst.fields[1]).to eq('666') }

    it 'when document empty' do
      2.times { document.next }
      expect { document.next }.to raise_error
    end
  end

  context '#fetch' do
    let(:fetched) { document.fetch }

    it { expect(fetched.name).to eq('ST') }
    it { expect(fetched.fields[0]).to eq('997') }
    it { expect(fetched.fields[1]).to eq('13666') }

    it 'when document empty' do
      2.times { document.fetch }
      expect { document.fetch }.to raise_error
    end
  end

  context '#empty?' do
    it { expect(document).not_to be_empty }
    it 'after fetch' do
      document.fetch
      expect(document).not_to be_empty
    end
    it 'after double fetch' do
      2.times { document.fetch }
      expect(document).to be_empty
    end
  end
end
