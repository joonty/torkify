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
    context "with a single observer" do
      let(:observer) { mock }
      subject { Dispatcher.new [observer] }

      context "dispatching an example event" do
        let(:event) { Event.new :example }

        it "should call on_example on the observer" do
          observer.should_receive(:on_example).with(event)
          subject.dispatch event
        end
      end
    end

    context "with multiple observers" do
      let(:observers) { [].fill mock, 0, 3 }
      subject { Dispatcher.new observers }

      context "dispatching an absorb event" do
        let(:event) { Event.new :absorb }

        it "should call on_absorb on the observer" do
          observers.each { |o| o.should_receive(:on_absorb).with(event) }
          subject.dispatch event
        end
      end

    end
  end
end
