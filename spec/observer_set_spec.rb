require 'spec_helper'
require 'torkify/observer_set'
require 'torkify/events/test_event'
require 'torkify/events/pass_or_fail_event'

module Torkify
  describe ObserverSet do
    before { @set = ObserverSet.new }
    subject { @set }

    it { should respond_to :length }
    it { should respond_to :add }
    it { should respond_to :<< }
    it { should respond_to :| }

    context "when empty" do
      its(:length) { should == 0 }
    end

    context "when calling union with an array" do
      before { @set |= [1, 3] }

      it           { should be_a ObserverSet }
      its(:length) { should == 2 }
      its(:to_a)   { should == [1, 3] }
    end

    context "when adding an array" do
      before { @set += [1, 3, 10] }

      it           { should be_a ObserverSet }
      its(:length) { should == 3 }
    end

    context "when it contains one observer" do
      before do
        @observer = Object.new
        @set.add @observer
      end

      its(:length) { should == 1 }

      context "with a pass event" do
        before { @event = Torkify::PassOrFailEvent.new 'pass', 1, [], 3, 4, 5, 6 }
        it "should call the pass method on the observer with dispatch" do
          @observer.should_receive(:on_pass).with(@event)
          @set.dispatch(@event)
        end
      end

      context "with a fail event" do
        before do
          @event = Torkify::PassOrFailEvent.new 'fail', 1, [], 3, 4, 5, 6
        end

        it "should call the fail method on the observer with dispatch" do
          @observer.should_receive(:on_fail).with(@event)
          @set.dispatch(@event)
        end

        it "should not raise an error on dispatch with unknown method" do
          expect { @set.dispatch(@event) }.not_to raise_error
        end

        it "should not raise an error on dispatch to method with wrong number of parameters" do
          def @observer.on_fail; end
          expect { @set.dispatch(@event) }.not_to raise_error
        end

        it "should not raise an error on dispatch to method that raises an exception" do
          @observer.should_receive(:on_fail).and_raise(RuntimeError)
          expect { @set.dispatch(@event) }.not_to raise_error
        end
      end
    end

    context "when it contains multiple observers" do
      before { @set += [double, double, double] }

      its(:length) { should == 3 }

      it "should call the pass method on every observer with dispatch" do
        event = Torkify::PassOrFailEvent.new 'pass', 1, [], 3, 4, 5, 6
        @set.each { |o| o.should_receive(:on_pass).with(event) }
        @set.dispatch(event)
      end

    end

    context "when trying to add the same object twice" do
      before do
        object = double
        @set.add object
        @set.add object
      end

      its(:length) { should == 1 }
    end
  end
end
