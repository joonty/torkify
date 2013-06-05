require 'spec_helper'
require 'torkify/event/basic_event'

module Torkify::Event
  describe BasicEvent do
    context "when type is absorb" do
      before do
        @event = BasicEvent.new('absorb')
      end

      subject { @event }

      its(:type) { should == 'absorb' }
      its(:to_s) { should == 'absorb' }
      its(:message) { should == :on_absorb }
    end

    context "when type is stop" do
      before do
        @event = BasicEvent.new('stop')
      end

      subject { @event }

      its(:type) { should == 'stop' }
      its(:to_s) { should == 'stop' }
      its(:message) { should == :on_stop }
    end
  end
end
