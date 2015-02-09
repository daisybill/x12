require 'spec_helper'

describe X12::Structures::Segment do
  let(:template) { TemplatesGenerator.generate( User: %w(name email age) ) }
  let(:segment) { template.create }

  context 'setters' do
    it { expect { segment.name = 'James Bond' }.to raise_error NotImplementedError }
    it { expect { segment.is_agemnt = true }.to raise_error NoMethodError }
  end

  context 'getters' do
    it { expect(segment.name).to be_nil }
    it { expect { segment.is_agent }.to raise_error NoMethodError }

    context 'when values present' do
      let(:values) { {name: 'John Smith', email: 'john.smith@gmail.com', age: 34} }
      let(:segment) { StructuresGenerator.generate template, values }

      it { expect(segment.name).to eq 'John Smith' }
      it { expect(segment.email).to eq 'john.smith@gmail.com' }
      it { expect(segment.age).to eq 34 }
    end
  end
end
