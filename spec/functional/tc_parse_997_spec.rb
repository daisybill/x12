require 'spec_helper'

describe "a 997 document" do
  subject { X12::Parser.new('misc/997.xml').parse('997', a_997_document) }

  it "parses the ST segment" do
    expect(subject.ST.to_s).to eq("ST*997*2878~")
    expect(subject.ST.TransactionSetIdentifierCode).to eq("997")
  end

  it "tests AK1" do
    expect(subject.AK1.GroupControlNumber).to eq('293328532')
  end

  it "tests AK2" do
    expect(subject.L1000.AK2.TransactionSetIdentifierCode).to eq('270')
  end

  it "tests L1010" do
    expect(subject.L1000.L1010.to_s).to match(/L1010_0/)
    expect(subject.L1000.L1010.to_a.size).to eq(3)
    expect(subject.L1000.L1010.size).to eq(3)
    expect(subject.L1000.L1010.to_a[2].to_s).to match(/L1010_2/)
    expect(subject.L1000.L1010[2].to_s).to match(/L1010_2/)
  end

  it "tests AK4" do
    expect(subject.L1000.L1010.to_a[1].AK4.to_s).to eq('AK4*1:0*66*1~')
    expect(subject.L1000.L1010[1].AK4.to_s).to eq('AK4*1:0*66*1~')
    expect(subject.L1000.L1010.AK4.to_a.size).to eq(3)
    expect(subject.L1000.L1010.AK4.size).to eq(3)
    expect(subject.L1000.L1010.to_a[1].AK4.to_a.size).to eq(2)
    expect(subject.L1000.L1010[1].AK4.size).to eq(2)
    expect(subject.L1000.L1010.to_a[1].AK4.to_a[1].to_s).to eq('AK4*1:1*66*1~')
    expect(subject.L1000.L1010[1].AK4[1].to_s).to eq('AK4*1:1*66*1~')
    expect(subject.L1000.L1010.AK4.DataElementReferenceNumber).to eq('66')
  end

  it "tests absent" do
    expect(subject.L1000.AK8.TransactionSetIdentifierCode).to eq(X12::Structures::EMPTY)
    expect(subject.L1000.L1111).to eq(X12::Structures::EMPTY)
    expect(subject.L1000.L1111.L2222).to eq(X12::Structures::EMPTY)
    expect(subject.L1000.L1111.L2222.AFAFA).to eq(X12::Structures::EMPTY)
    expect(subject.L1000.L1010[-99]).to eq(X12::Structures::EMPTY)
    expect(subject.L1000.L1010[99]).to eq(X12::Structures::EMPTY)
    expect(subject.L1000.L1010[99].AK4).to eq(X12::Structures::EMPTY)

    expect(subject.L1000.AK8.TransactionSetIdentifierCode.to_s).to eq('')
  end

  def a_997_document
'ST*997*2878~
AK1*HS*293328532~
AK2*270*307272179~
AK3*NM1*8*L1010_0*8~
AK4*0:0*66*1~
AK4*0:1*66*1~
AK4*0:2*66*1~
AK3*NM1*8*L1010_1*8~
AK4*1:0*66*1~
AK4*1:1*66*1~
AK3*NM1*8*L1010_2*8~
AK4*2:0*66*1~
AK5*R*5~
AK9*R*1*1*0~
SE*8*2878~
'.gsub(/\n/, "")
  end
end

