require 'spec_helper'

describe "a 997 document" do
  subject { X12::Parser.new('misc/270.xml').parse('270', document) }

  it "tests ST" do
    expect(subject.ST.to_s).to eq('ST*270*1001~')
    expect(subject.ST.TransactionSetIdentifierCode).to eq('270')
  end

  it "tests L2000A_NM1" do
    expect(subject.L2000A.L2100A.NM1.NameLastOrOrganizationName).to eq('BIG PAYOR')
  end

  it "tests L2000C_NM1" do
    expect(subject.L2000C.L2100C.NM1.NameFirst).to eq('Joe')
  end

  it "tests L2000A_HL" do
    expect(subject.L2000A.HL.HierarchicalParentIdNumber).to eq('')
  end

  it "tests absent" do
    expect(subject.L2000D.HHH).to eq(X12::EMPTY)
    expect(subject.L2000B.L2111).to eq(X12::EMPTY)
    expect(subject.L2000C.L2100C.N3.AddressInformation1).to eq('')
  end

  def document
'ST*270*1001~
BHT*0022*13*LNKJNFGRWDLR*20070724*1726~
HL*1**20*1~
NM1*PR*2*BIG PAYOR*****PI*CHICAGO BLUES~
HL*2*1*21*1~
NM1*1P*1******SV*daw~
HL*3*2*22*0~
NM1*IL*1*Doe*Joe~
DMG*D8*19700725~
DTP*307*D8*20070724~
EQ*60~
SE*12*1001~
'.gsub(/\n/,'')
  end

end

