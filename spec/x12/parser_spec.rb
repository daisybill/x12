require 'spec_helper'

describe X12::NewParser do
  let(:parser) { X12::NewParser.new(X12::Templates::Xml.new template_path) }
  let(:structure) { parser.parse(File.read file_path) }

  context 'all_defined' do
    let(:template_path) { "#{X12::ROOT}/spec/misc/all_defined.xml" }
    let(:file_path) { "#{X12::ROOT}/spec/misc/all_defined.x12" }

    it { expect(structure).to be_a X12::Structures::Base }
    it { expect(structure.ST.TransactionSetIdentifierCode).to eq('997') }
    it { expect(structure.ST.TransactionSetControlNumber).to eq('13666') }

    it { expect(structure.AK3).to be_a X12::Structures::Segment }
    it { expect(structure.AK3.AdjustmentReasonCode).to eq('13') }
    it { expect(structure.AK3.ReferenceIdentificationQualifier).to eq('666') }
  end

  context 'only_names' do
    let(:template_path) { "#{X12::ROOT}/spec/misc/only_names.xml" }
    let(:file_path) { "#{X12::ROOT}/spec/misc/only_names.x12" }

    let(:data) {
      [
        %w(997 13666 13 666),
        %w(997 23134 89 546),
        %w(997 76585 47 356)
      ]
    }

    it { expect(structure).to be_a X12::Structures::Base }
    it { expect(structure.all_defined).to be_a X12::Structures::Loop }
    it { expect(structure.all_defined.size).to eq(3) }

    it 'check all_defined loop' do
      i = 0
      structure.all_defined.each { |l|
        expect(l.ST.TransactionSetIdentifierCode).to eq(data[i][0])
        expect(l.ST.TransactionSetControlNumber).to eq(data[i][1])
        expect(l.AK3.AdjustmentReasonCode).to eq(data[i][2])
        expect(l.AK3.ReferenceIdentificationQualifier).to eq(data[i][3])
        i += 1
      }
    end

    it { expect(structure.NTE).to be_a X12::Structures::Segment }
    it { expect(structure.NTE.NoteReferenceCode).to eq '98' }
    it { expect(structure.NTE.Description).to eq 'In this document must be 3 all defined loops and one NTE segment' }
  end
end
