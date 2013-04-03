require 'spec_helper'

module Torkify
  describe StatusChangeEvent do

    context "with a pass_now_fail event" do
      before do
        @type = 'pass_now_fail'
        @file = 'file'
        @inner_event = PassOrFailEvent.new(*(1..7))
        @event = StatusChangeEvent.new(@test, @file, @inner_event)
      end

      subject { @event }

      its(:type)  { should == @test }
      its(:file)  { should == @file }
      its(:event) { should == @inner_event }
    end

    context "with a fail_now_pass event" do
      before do
        @type = 'fail_now_pass'
        @file = 'file'
        @inner_event = PassOrFailEvent.new(*(1..7))
        @event = StatusChangeEvent.new(@test, @file, @inner_event)
      end

      subject { @event }

      its(:type)  { should == @test }
      its(:file)  { should == @file }
      its(:event) { should == @inner_event }
    end
  end
end
