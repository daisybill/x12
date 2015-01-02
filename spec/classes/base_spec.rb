require 'spec_helper'

describe X12::Structures::Base do
  context "with no sub nodes" do
    subject { X12::Structures::Base.new("TEST", []) }

    describe "#find" do
      it "can't find anything underneath it" do
        expect(subject.find("foo")).to eq(X12::Structures::EMPTY)
      end
    end
  end
end

