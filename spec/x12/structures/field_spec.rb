require 'spec_helper'

describe X12::Structures::Field do
  let(:template) { TemplatesGenerator.field 'field' }
  let(:field) { template.create }

  context '#to_s' do
    it 'when value integer' do
      field.value = 13666
      expect(field.to_s).to eq('13666')
    end
  end
end
