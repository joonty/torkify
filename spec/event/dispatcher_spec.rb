require 'spec_helper'
require 'torkify/event/dispatcher'
require 'torkify/event/event'

module Torkify::Event

  class ExampleObserver
    def on_test(event)
    end

    def on_pass
    end
  end

  describe Dispatcher do
    shared_examples "an observer notification" do
      it "should send the expected message to the observer" do
        observers.each { |o| o.should_receive(expected_message).with(event) }
        subject.dispatch event
      end
    end

    context "with a single observer" do
      let(:observers) { [mock] }
      subject { Dispatcher.new observers }

      context "dispatching an example event" do
        let(:event) { Event.new :example }
        let(:expected_message) { :on_example }

        it_behaves_like "an observer notification"
      end
    end

    context "with multiple observers" do
      let(:observers) { [].fill mock, 0, 3 }
      subject { Dispatcher.new observers }

      context "dispatching an absorb event" do
        let(:event) { Event.new :absorb }
        let(:expected_message) { :on_absorb }

        it_behaves_like "an observer notification"
      end

    end
  end
end
