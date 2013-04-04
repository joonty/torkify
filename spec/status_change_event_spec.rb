require 'spec_helper'
require 'torkify/events/status_change_event'
require 'torkify/events/pass_or_fail_event'

module Torkify
  describe StatusChangeEvent do

    context "with a pass_now_fail event" do
      before do
        @type = 'pass_now_fail'
        @file = 'file'
        @inner_event = PassOrFailEvent.new(*(1..7))
        @event = StatusChangeEvent.new(@type, @file, @inner_event)
      end

      subject { @event }

      its(:type)  { should == @type }
      its(:file)  { should == @file }
      its(:event) { should == @inner_event }
      its(:to_s)  { should == 'PASS NOW FAIL file' }
      its(:message)  { should == :on_pass_now_fail }
    end

    context "with a fail_now_pass event" do
      before do
        @type = 'fail_now_pass'
        @file = 'file'
        @inner_event = PassOrFailEvent.new(*(1..7))
        @event = StatusChangeEvent.new(@type, @file, @inner_event)
      end

      subject { @event }

      its(:type)  { should == @type }
      its(:file)  { should == @file }
      its(:event) { should == @inner_event }
      its(:to_s)  { should == 'FAIL NOW PASS file' }
      its(:message)  { should == :on_fail_now_pass }
    end
  end
end
