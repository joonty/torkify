require 'spec_helper'
require 'torkify/events/event'

module Torkify
  describe Event do
    context "when type is absorb" do
      before do
        @event = Event.new('absorb')
      end

      subject { @event }

      its(:type) { should == 'absorb' }
      its(:to_s) { should == 'absorb' }
      its(:message) { should == :on_absorb }
    end
  end
end
