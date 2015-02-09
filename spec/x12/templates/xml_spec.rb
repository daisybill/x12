require 'spec_helper'

describe X12::Templates::Xml do
  let(:template) { X12::Templates::Xml.new(file_name) }

  context 'when file does not exist' do
    let(:file_name) { '/not/existing/file' }

    it { expect { template }.to raise_error }
  end

  context 'when file name passed with extension' do
    let(:file_name) { "#{X12::ROOT}/spec/misc/all_defined.xml" }

    it { expect { template }.not_to raise_error }
  end

  context 'when incorrect root node' do
    let(:file_name) { "#{X12::ROOT}/spec/misc/fields" }

    it { expect { template }.to raise_error }
  end

  context 'when there are no Loop in Definition' do
    let(:file_name) { "#{X12::ROOT}/spec/misc/not_loop" }

    it { expect { template }.to raise_error }
  end

  context 'when there are more than one child in Definition' do
    let(:file_name) { "#{X12::ROOT}/spec/misc/not_loop" }

    it { expect { template }.to raise_error }
  end

  context 'when all defined' do
    let(:file_name) { "#{X12::ROOT}/spec/misc/all_defined" }

    it { expect(template.children.count).to eq(2) }
    context 'first child' do
      let(:child) { template.children[0] }

      it { expect(child).to be_kind_of X12::Templates::Segment }
      it { expect(child.name).to eq('ST') }
      it { expect(child.children.count).to eq(2) }
      it { expect(child.children[0]).to be_kind_of X12::Templates::Field }
      it { expect(child.children[0].name).to eq('TransactionSetIdentifierCode') }
      it { expect(child.children[1]).to be_kind_of X12::Templates::Field }
      it { expect(child.children[1].name).to eq('TransactionSetControlNumber') }
    end

    context 'second child' do
      let(:child) { template.children[1] }

      it { expect(child).to be_kind_of X12::Templates::Segment }
      it { expect(child.name).to eq('AK3') }
      it { expect(child.children.count).to eq(2) }
      it { expect(child.children[0]).to be_kind_of X12::Templates::Field }
      it { expect(child.children[0].name).to eq('AdjustmentReasonCode') }
      it { expect(child.children[1]).to be_kind_of X12::Templates::Field }
      it { expect(child.children[1].name).to eq('ReferenceIdentificationQualifier') }
    end
  end

  context 'when defined only name' do
    let(:file_name) { "#{X12::ROOT}/spec/misc/only_names" }

    it { expect(template.children.count).to eq(2) }

    context 'NTE Segment' do
      let(:segment) { template.children[0] }

      it { expect(segment).to be_kind_of X12::Templates::Segment }
      it { expect(segment.children.count).to eq(2) }
      it { expect(segment.children[0]).to be_kind_of X12::Templates::Field }
      it { expect(segment.children[0].name).to eq('NoteReferenceCode') }
      it { expect(segment.children[1]).to be_kind_of X12::Templates::Field }
      it { expect(segment.children[1].name).to eq('Description') }
    end

    context 'all_defined loop' do
      let(:loop) { template.children[1] }

      it { expect(loop).to be_kind_of X12::Templates::Loop }
      it { expect(loop.children.count).to eq(2) }
      context 'first child' do
        let(:child) { loop.children[0] }

        it { expect(child).to be_kind_of X12::Templates::Segment }
        it { expect(child.name).to eq('ST') }
        it { expect(child.children.count).to eq(2) }
        it { expect(child.children[0]).to be_kind_of X12::Templates::Field }
        it { expect(child.children[0].name).to eq('TransactionSetIdentifierCode') }
        it { expect(child.children[1]).to be_kind_of X12::Templates::Field }
        it { expect(child.children[1].name).to eq('TransactionSetControlNumber') }
      end

      context 'second child' do
        let(:child) { loop.children[1] }

        it { expect(child).to be_kind_of X12::Templates::Segment }
        it { expect(child.name).to eq('AK3') }
        it { expect(child.children.count).to eq(2) }
        it { expect(child.children[0]).to be_kind_of X12::Templates::Field }
        it { expect(child.children[0].name).to eq('AdjustmentReasonCode') }
        it { expect(child.children[1]).to be_kind_of X12::Templates::Field }
        it { expect(child.children[1].name).to eq('ReferenceIdentificationQualifier') }
      end
    end
  end
end
