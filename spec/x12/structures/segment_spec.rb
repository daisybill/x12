require 'spec_helper'

describe X12::Structures::Segment do
  let(:template) do
    result = X12::Templates::Segment.new 'User', required: false
    result.children = %w(name email age).map { |f|
      X12::Templates::Field.new f, range: 1..20, required: false, validation: false
    }
    result
  end
  let(:segment) { template.create }

  context 'setters' do
    it { expect { segment.name = 'James Bond' }.to_not raise_error }
    it { expect { segment.is_agemnt = true }.to raise_error }
  end

  context 'getters' do
    it { expect(segment.name).to be_nil }
    it { expect { segment.is_agemnt }.to raise_error }

    context 'when values present' do
      before do
        segment.name = 'John Smith'
        segment.email = 'john.smith@gmail.com'
        segment.age = 34
      end

      it { expect(segment.name).to eq 'John Smith' }
      it { expect(segment.email).to eq 'john.smith@gmail.com' }
      it { expect(segment.age).to eq 34 }
    end
  end
end
