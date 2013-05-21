require 'spec_helper'
require 'torkify/events/echo_event'

module Torkify
  describe EchoEvent do

    context "with a pass_now_fail event" do
      before do
        @type = 'echo'
        @arguments = ['a']
        @event = EchoEvent.new(@type, @arguments)
      end

      subject { @event }

      its(:type)      { should == @type }
      its(:arguments) { should == @arguments }
      its(:args)      { should == @arguments }
      its(:to_s)      { should == @type }
    end
  end
end
