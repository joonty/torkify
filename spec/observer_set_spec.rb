require 'spec_helper'

module Torkify
  describe ObserverSet do
    before do
      @set = ObserverSet.new
    end
    subject { @set }

    it { should respond_to :length }
    it { should respond_to :add }

    context "when empty" do
      its(:length) { should == 0 }
    end

    context "when it contains one observer" do
      before do
        @set = ObserverSet.new
        @set.add Object.new
      end

      its(:length) { should == 1 }
    end

    context "when it contains multiple observers" do
      before do
        @set = ObserverSet.new
        @set.add Object.new
        @set.add Object.new
        @set.add Object.new
      end

      its(:length) { should == 3 }
    end
  end
end
