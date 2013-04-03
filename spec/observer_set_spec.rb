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
        @observer = double
        @set.add @observer
      end

      its(:length) { should == 1 }

      it "should call the pass method on the observer with dispatch" do
        event = Torkify::PassOrFailEvent.new 'pass', *(1..6)
        @observer.should_receive(:pass).with(event)
        @set.dispatch(event)
      end

      it "should call the fail method on the observer with dispatch" do
        event = Torkify::PassOrFailEvent.new 'fail', *(1..6)
        @observer.should_receive(:fail).with(event)
        @set.dispatch(event)
      end
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

    context "when trying to add the same object twice" do
      before do
        @set = ObserverSet.new
        object = Object.new
        @set.add object
        @set.add object
      end

      its(:length) { should == 1 }
    end
  end
end
