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
        @observer = Object.new
        @set.add @observer
      end

      its(:length) { should == 1 }

      it "should call the pass method on the observer with dispatch" do
        event = Torkify::PassOrFailEvent.new 'pass', *(1..6)
        @observer.should_receive(:on_pass).with(event)
        @set.dispatch(event)
      end

      it "should call the fail method on the observer with dispatch" do
        event = Torkify::PassOrFailEvent.new 'fail', *(1..6)
        @observer.should_receive(:on_fail).with(event)
        @set.dispatch(event)
      end

      it "should not raise an error on dispatch with unknown method" do
        event = Torkify::PassOrFailEvent.new 'fail', *(1..6)
        expect { @set.dispatch(event) }.not_to raise_error
      end
    end

    context "when it contains multiple observers" do
      before do
        @set = ObserverSet.new
        @set.add double
        @set.add double
        @set.add double
      end

      its(:length) { should == 3 }

      it "should call the pass method on every observer with dispatch" do
        event = Torkify::PassOrFailEvent.new 'pass', *(1..6)
        @set.each { |o| o.should_receive(:on_pass).with(event) }
        @set.dispatch(event)
      end

    end

    context "when trying to add the same object twice" do
      before do
        @set = ObserverSet.new
        object = double
        @set.add object
        @set.add object
      end

      its(:length) { should == 1 }
    end
  end
end
