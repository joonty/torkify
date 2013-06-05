require 'spec_helper'
require 'torkify/event/dispatcher'
require 'torkify/event/basic_event'
require 'torkify/event/pass_or_fail_event'

module Torkify::Event

  class ExampleObserver
    def on_stop(event, a1, a2, a3, a4, a5)
      receive :on_stop, event, a1, a2, a3, a4, a5
    end

    def on_fail(event, another)
      receive :on_fail, event, another
    end

    def on_test(event)
      receive :on_test, event
    end

    def method_missing(name, *args)
      receive name, *args
    end

    def on_pass
      receive :on_pass
    end

    def receive(message, *args)
      @received = [message, *args]
    end

    attr_reader :received
  end

  describe Dispatcher do
    shared_examples "an observer notification" do
      it "should send the expected message and event to the observer" do
        observers.each { |o| o.should_receive(expected_message).with(event) }
        subject.dispatch event
      end
    end

    shared_examples "an observer with a called method" do
      before { dispatcher.dispatch(event) }
      subject { observers.first }

      its(:received) { should == expected_call }
    end

    context "with a single observer" do
      let(:observers) { [mock] }
      subject { Dispatcher.new observers }

      context "dispatching an example event" do
        let(:event) { BasicEvent.new :example }
        let(:expected_message) { :on_example }

        it_behaves_like "an observer notification"
      end

      context "dispatching a test event" do
        let(:event) { BasicEvent.new :test }
        let(:expected_message) { :on_test }

        it_behaves_like "an observer notification"
      end

    end

    context "with a concrete observer" do
      let(:observers)  { [ ExampleObserver.new ] }
      let(:dispatcher) { Dispatcher.new observers }

      context "dispatching to a method that receives no arguments" do
        let(:event) { BasicEvent.new :pass }
        let(:expected_call) { [:on_pass] }

        it_behaves_like "an observer with a called method"
      end

      context "dispatching to a method that receives one argument" do
        let(:event) { BasicEvent.new :test }
        let(:expected_call) { [:on_test, event] }

        it_behaves_like "an observer with a called method"
      end

      context "dispatching to a method that receives two arguments" do
        let(:event) { BasicEvent.new :fail }
        let(:expected_call) { [:on_fail, event, nil] }

        it_behaves_like "an observer with a called method"
      end

      context "dispatching to a method that receives many arguments" do
        let(:event) { BasicEvent.new :stop }
        let(:expected_call) { [:on_stop, event, nil, nil, nil, nil, nil] }

        it_behaves_like "an observer with a called method"
      end

      context "dispatching to use method missing" do
        let(:event) { BasicEvent.new :unknown }
        let(:expected_call) { [:on_unknown, event] }

        it_behaves_like "an observer with a called method"
      end

      context "dispatching a run all test files event" do
        let(:event) { BasicEvent.new :run_all_test_files }
        let(:expected_call) { [:on_run_all_test_files, event] }

        before { dispatcher.dispatch event }

        it_behaves_like "an observer with a called method"

        context "after sending the idle event" do
          before { dispatcher.dispatch BasicEvent.new :idle }

          subject { observers.first.received }

          its(:first) { should == :on_ran_all_test_files }

          context "the event" do
            subject { observers.first.received[1] }
            it { should be_a RanAllTestFilesEvent }
            its(:passed) { should == [] }
            its(:failed) { should == [] }
            its(:time) { should > 0.0 }
          end
        end

        context "after sending several pass and fail events" do
          let(:pass_events) { Array.new(3) { PassOrFailEvent.new(:pass) } }
          let(:fail_events) { Array.new(3) { PassOrFailEvent.new(:fail) } }

          before do
            pass_events.each { |e| dispatcher.dispatch e }
            fail_events.each { |e| dispatcher.dispatch e }
            dispatcher.dispatch BasicEvent.new :idle
          end

          subject { observers.first.received }

          its(:first) { should == :on_ran_all_test_files }

          context "the event" do
            subject { observers.first.received[1] }
            it { should be_a RanAllTestFilesEvent }
            its(:passed) { should == pass_events }
            its(:failed) { should == fail_events }
            its(:time) { should > 0.0 }
          end
        end
      end
    end

    context "with an observer that has no methods" do
      let(:observers) { [Object.new] }

      let(:dispatcher) { Dispatcher.new observers }

      context "dispatching an event" do
        it "should not raise an exception" do
          expect { dispatcher.dispatch BasicEvent.new(:missing) }.not_to raise_error
        end
      end
    end

    context "with multiple observers" do
      let(:observers) { Array.new(3) { mock } }
      subject { Dispatcher.new observers }

      context "dispatching an absorb event" do
        let(:event) { BasicEvent.new :absorb }
        let(:expected_message) { :on_absorb }

        it_behaves_like "an observer notification"
      end

      context "dispatching a fail event" do
        let(:event) { BasicEvent.new :fail }
        let(:expected_message) { :on_fail }

        it_behaves_like "an observer notification"
      end
    end
  end
end
