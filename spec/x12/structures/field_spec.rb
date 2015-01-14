require 'spec_helper'

describe X12::Structures::Field do
  let(:template) { X12::Templates::Field.new 'field', range: 1..10, required: false, validation: false }
  let(:field) { template.create }

  context '#to_s' do
    it 'when value integer' do
      field.value = 13666
      expect(field.to_s).to eq('13666')
    end
  end
end
