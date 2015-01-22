require 'spec_helper'

describe X12::NewParser do
  let(:parser) { X12::NewParser.new(X12::Templates::Xml.new template_path) }
  let(:structure) { parser.parse(File.read(file_path).strip.gsub(/(~)\n\s*/,'\1')) }

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

  context '277' do
    let(:template_path) { "#{X12::ROOT}/spec/misc/277.xml" }

    context 'simple' do
      let(:file_path) { "#{X12::ROOT}/spec/misc/simple277.x12" }

      it { expect(structure).to be_a X12::Structures::Base }

      it { expect(structure.ISA).to be_a X12::Structures::Segment }
      it { expect(structure.GS).to be_a X12::Structures::Segment }
      it { expect(structure.L0000).to be_a X12::Structures::Loop }
      it { expect(structure.L0000.size).to eq(1) }
      it { expect(structure.GE).to be_a X12::Structures::Segment }
      it { expect(structure.IEA).to be_a X12::Structures::Segment }

      context 'L0000' do
        let(:l0000) { structure.L0000 }

        it { expect(l0000.ST).to be_a X12::Structures::Segment }
        it { expect(l0000.BHT).to be_a X12::Structures::Segment }
        it { expect(l0000.L2000A).to be_a X12::Structures::Loop }
        it { expect(l0000.L2000A.size).to eq(1) }
        it { expect(l0000.SE).to be_a X12::Structures::Segment }

        context 'L2000A' do
          let(:l2000a) { l0000.L2000A }

          it { expect(l2000a.HL).to be_a X12::Structures::Segment }
          it { expect(l2000a.L2100A).to be_a X12::Structures::Loop }
          it { expect(l2000a.L2100A.size).to eq(1) }
          it { expect(l2000a.L2100A.NM1).to be_a X12::Structures::Segment }
          it { expect(l2000a.L2100A.NM1.NameLastOrOrganizationName).to eq('HOLLYWOOD UNDEAD') }

          it { expect(l2000a.L2200A).to be_a X12::Structures::Loop }
          it { expect(l2000a.L2200A.size).to eq(1) }

          it { expect(l2000a.L2000B).to be_a X12::Structures::Loop }
          it { expect(l2000a.L2000B.size).to eq(1) }

          context 'L2200A' do
            let(:l2200a) { l2000a.L2200A }

            it { expect(l2200a.TRN).to be_a X12::Structures::Segment }
            it { expect(l2200a.DTP).to be_a Array }
            it { expect(l2200a.DTP.size).to eq(2) }
            it { expect(l2200a.DTP[0]).to be_a X12::Structures::Segment }
            it { expect(l2200a.DTP[1]).to be_a X12::Structures::Segment }
          end

          context 'L2000B' do
            let(:l2000b) { l2000a.L2000B }

            it { expect(l2000b.HL).to be_a X12::Structures::Segment }
            it { expect(l2000b.L2100B).to be_a X12::Structures::Loop }
            it { expect(l2000b.L2100B.size).to eq(1) }
            it { expect(l2000b.L2100B.NM1).to be_a X12::Structures::Segment }
            it { expect(l2000b.L2100B.NM1.NameLastOrOrganizationName).to eq('PAIN') }

            it { expect(l2000b.L2200B).to be_a X12::Structures::Loop }
            it { expect(l2000b.L2200B.size).to eq(1) }

            it { expect(l2000b.L2000C).to be_a X12::Structures::Loop }
            it { expect(l2000b.L2000C.size).to eq(1) }

            context 'L2200B' do
              let(:l2200b) { l2000b.L2200B }

              it { expect(l2200b.TRN).to be_a X12::Structures::Segment }
              it { expect(l2200b.STC).to be_a X12::Structures::Segment }
              it { expect(l2200b.QTY).to be_a X12::Structures::Segment }
              it { expect(l2200b.AMT).to be_a X12::Structures::Segment }
            end

            context 'L2000C' do
              let(:l2000c) { l2000b.L2000C }

              it { expect(l2000c.HL).to be_a X12::Structures::Segment }

              it { expect(l2000c.L2100C).to be_a X12::Structures::Loop }
              it { expect(l2000c.L2100C.size).to eq(1) }
              it { expect(l2000c.L2100C.NM1).to be_a X12::Structures::Segment }
              it { expect(l2000c.L2100C.NM1.NameLastOrOrganizationName).to eq('ARKHAM MEDICINE CENTER') }
              it { expect(l2000c.L2200C).to be_nil }
              it { expect(l2000c.L2000D).to be_a X12::Structures::Loop }
              it { expect(l2000c.L2000D.size).to eq(1) }

              context 'L2000D' do
                let(:l2000d) { l2000c.L2000D }

                it { expect(l2000d.HL).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2100D).to be_a X12::Structures::Loop }
                it { expect(l2000d.L2100D.size).to eq(1) }
                it { expect(l2000d.L2100D.NM1).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2100D.NM1.NameLastOrOrganizationName).to eq('Edward') }
                it { expect(l2000d.L2100D.NM1.NameFirst).to eq('Nigma') }
                it { expect(l2000d.L2200D).to be_a X12::Structures::Loop }
                it { expect(l2000d.L2200D.size).to eq(1) }
                it { expect(l2000d.L2200D.TRN).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2200D.STC).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2200D.STC.HealthCareClaimStatus1).to eq('A1:20:PR') }
                it { expect(l2000d.L2200D.STC.Date1).to eq('20141211') }
                it { expect(l2000d.L2200D.DTP).to be_a X12::Structures::Segment }
              end
            end
          end
        end
      end
    end

    context 'double' do
      let(:file_path) { "#{X12::ROOT}/spec/misc/double277.x12" }

      it { expect(structure).to be_a X12::Structures::Base }

      it { expect(structure.ISA).to be_a X12::Structures::Segment }
      it { expect(structure.GS).to be_a X12::Structures::Segment }
      it { expect(structure.L0000).to be_a X12::Structures::Loop }
      it { expect(structure.L0000.size).to eq(2) }
      it { expect(structure.GE).to be_a X12::Structures::Segment }
      it { expect(structure.IEA).to be_a X12::Structures::Segment }

      context 'L0000' do
        let(:l0000) { structure.L0000[0] }

        it { expect(l0000.size).to eq(2) }
        it { expect(l0000.ST).to be_a X12::Structures::Segment }
        it { expect(l0000.BHT).to be_a X12::Structures::Segment }
        it { expect(l0000.L2000A).to be_a X12::Structures::Loop }
        it { expect(l0000.L2000A.size).to eq(1) }
        it { expect(l0000.SE).to be_a X12::Structures::Segment }

        context 'L2000A' do
          let(:l2000a) { l0000.L2000A }

          it { expect(l2000a.HL).to be_a X12::Structures::Segment }
          it { expect(l2000a.L2100A).to be_a X12::Structures::Loop }
          it { expect(l2000a.L2100A.size).to eq(1) }
          it { expect(l2000a.L2100A.NM1).to be_a X12::Structures::Segment }
          it { expect(l2000a.L2100A.NM1.NameLastOrOrganizationName).to eq('Sacred Heart') }

          it { expect(l2000a.L2200A).to be_a X12::Structures::Loop }
          it { expect(l2000a.L2200A.size).to eq(1) }

          it { expect(l2000a.L2000B).to be_a X12::Structures::Loop }
          it { expect(l2000a.L2000B.size).to eq(1) }

          context 'L2200A' do
            let(:l2200a) { l2000a.L2200A }

            it { expect(l2200a.TRN).to be_a X12::Structures::Segment }
            it { expect(l2200a.DTP).to be_a Array }
            it { expect(l2200a.DTP.size).to eq(2) }
            it { expect(l2200a.DTP[0]).to be_a X12::Structures::Segment }
            it { expect(l2200a.DTP[1]).to be_a X12::Structures::Segment }
          end

          context 'L2000B' do
            let(:l2000b) { l2000a.L2000B }

            it { expect(l2000b.HL).to be_a X12::Structures::Segment }
            it { expect(l2000b.L2100B).to be_a X12::Structures::Loop }
            it { expect(l2000b.L2100B.size).to eq(1) }
            it { expect(l2000b.L2100B.NM1).to be_a X12::Structures::Segment }
            it { expect(l2000b.L2100B.NM1.NameLastOrOrganizationName).to eq('Zachary Israel "Zach" Braff') }

            it { expect(l2000b.L2200B).to be_a X12::Structures::Loop }
            it { expect(l2000b.L2200B.size).to eq(1) }

            it { expect(l2000b.L2000C).to be_a X12::Structures::Loop }
            it { expect(l2000b.L2000C.size).to eq(1) }

            context 'L2200B' do
              let(:l2200b) { l2000b.L2200B }

              it { expect(l2200b.TRN).to be_a X12::Structures::Segment }
              it { expect(l2200b.STC).to be_a X12::Structures::Segment }
              it { expect(l2200b.QTY).to be_a X12::Structures::Segment }
              it { expect(l2200b.AMT).to be_a X12::Structures::Segment }
            end

            context 'L2000C' do
              let(:l2000c) { l2000b.L2000C }

              it { expect(l2000c.HL).to be_a X12::Structures::Segment }

              it { expect(l2000c.L2100C).to be_a X12::Structures::Loop }
              it { expect(l2000c.L2100C.size).to eq(1) }
              it { expect(l2000c.L2100C.NM1).to be_a X12::Structures::Segment }
              it { expect(l2000c.L2100C.NM1.NameLastOrOrganizationName).to eq('John Dorian') }
              it { expect(l2000c.L2200C).to be_nil }
              it { expect(l2000c.L2000D).to be_a X12::Structures::Loop }
              it { expect(l2000c.L2000D.size).to eq(1) }

              context 'L2000D' do
                let(:l2000d) { l2000c.L2000D }

                it { expect(l2000d.HL).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2100D).to be_a X12::Structures::Loop }
                it { expect(l2000d.L2100D.size).to eq(1) }
                it { expect(l2000d.L2100D.NM1).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2100D.NM1.NameLastOrOrganizationName).to eq('John') }
                it { expect(l2000d.L2100D.NM1.NameFirst).to eq('Smith') }
                it { expect(l2000d.L2200D).to be_a X12::Structures::Loop }
                it { expect(l2000d.L2200D.size).to eq(1) }
                it { expect(l2000d.L2200D.TRN).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2200D.STC).to be_a Array }
                it { expect(l2000d.L2200D.STC.size).to eq(2) }
                it { expect(l2000d.L2200D.STC[0]).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2200D.STC[0].HealthCareClaimStatus1).to eq('A7:97:PR') }
                it { expect(l2000d.L2200D.STC[0].Date1).to eq('20141211') }
                it { expect(l2000d.L2200D.STC[1]).to be_a X12::Structures::Segment }
                it { expect(l2000d.L2200D.STC[1].HealthCareClaimStatus1).to eq('A7:629') }
                it { expect(l2000d.L2200D.STC[1].Date1).to eq('20141211') }
                it { expect(l2000d.L2200D.DTP).to be_a X12::Structures::Segment }
              end
            end
          end
        end
      end
    end
  end
end
