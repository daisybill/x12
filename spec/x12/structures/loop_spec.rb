require 'spec_helper'

describe X12::Structures::Loop do
  let(:data) do
    [
      {
        User: { name: 'John Smith', email: 'john.smith@gmail.com', age: 34 },
        Devices: [
          {
            Laptop: { brand: 'Asus', CPU: 'i7', RAM: 8 },
            Smartphone: { brand: 'Jiayu', size: 4.7 }
          },
          { Smartphone: { brand: 'THL', size: 5.0 } }
        ]
      },
      {
        User: { name: 'James Bond', email: '007@gmail.com', age: 32 },
        Devices: []
      }
    ]
  end
  let(:template) do
    TemplatesGenerator.generate({
      Employees: {
        User: %w(name email age),
        Devices: {
          Laptop: %w(brand CPU RAM),
          Smartphone: %w(brand size)
        }
      }
    })
  end
  let(:loop) { template.create }

  context 'setters' do
    it { expect { loop.User = nil }.to raise_error NotImplementedError }
    it { expect { loop.Devices = nil }.to raise_error NotImplementedError }
    it { expect { loop.Laptop = nil }.to raise_error }
  end

  context 'getters' do
    it { expect(loop.User).to be_nil  }
    it { loop.User { |user| expect(user).to be_nil } }
    it { expect(loop.Devices).to be_nil  }
    it { loop.Devices { |devices| expect(devices).to be_nil } }
    it { expect { loop.Laptop }.to raise_error }
  end

  context '#[]' do
    let(:loop) { StructuresGenerator.generate template, data }

    it { expect(loop).to be_a X12::Structures::Loop }

    it { expect(loop[0]).to be_a X12::Structures::Loop }
    it { expect(loop[0].User).to be_a X12::Structures::Segment }
    it { expect(loop[0].Devices).to be_a X12::Structures::Loop }

    it { expect(loop[1]).to be_a X12::Structures::Loop }
    it { expect(loop[1].User).to be_a X12::Structures::Segment }
    it { expect(loop[1].Devices).to be_nil }

    it { expect(loop[2]).to be_nil }
  end

  context '#size' do
    it { expect(StructuresGenerator.generate(template, data).size).to eq(2) }
    # it { expect(StructuresGenerator.generate(template, []).size).to eq(0) }
    it { expect(template.create.size).to eq(0) }
  end

  # context '#empty?' do
  #   it { expect(StructuresGenerator.generate(template, data)).to_not be_empty }
  #   it { expect(StructuresGenerator.generate(template, [])).to be_empty }
  #   it { expect(template.create).to be_empty }
  # end

  context '#repeat' do
    it { expect { loop.repeat }.to raise_error LocalJumpError }
    it { expect { loop.repeat {|l| } }.to change { loop.size }.by(+1) }
  end

  context '#each' do
    let(:loop) { StructuresGenerator.generate(template, data) }
    let(:iterator) { 0 }

    it { expect { loop.each { |l| iterator += 1 }.to change { iterator }.by (+2) } }
  end

  context '#next' do
    it { expect { loop.next }.to change { loop.size }.by(+1) }
  end
end
