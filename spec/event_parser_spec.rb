require 'spec_helper'
require 'torkify/event_parser'

module Torkify
  describe EventParser do
    before { @parser = EventParser.new }

    context "when calling parse on a test event line with no numbers" do
      before do
        line = '["test","spec/reader_spec.rb",[],"spec/reader_spec.rb.log",3]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a TestEvent }

      its(:file)     { should == 'spec/reader_spec.rb' }
      its(:lines)    { should == [] }
      its(:log_file) { should == 'spec/reader_spec.rb.log' }
      its(:worker)   { should == 3 }
    end

    context "when calling parse on a test event line with numbers" do
      before do
        line = '["test","spec/another_spec.rb",[20, 32, 41],"spec/another_spec.rb.log",6]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a TestEvent }

      its(:file)     { should == 'spec/another_spec.rb' }
      its(:lines)    { should == [20, 32, 41] }
      its(:log_file) { should == 'spec/another_spec.rb.log' }
      its(:worker)   { should == 6 }
    end

    context "when calling parse on a pass event line" do
      before do
        line = '["pass","spec/pass_spec.rb",[27],"spec/pass_spec.rb.log",1,0,"#<Process::Status: pid 27490 exit 0>"]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a PassOrFailEvent }
      its(:type)      { should == 'pass' }
      its(:file)      { should == 'spec/pass_spec.rb' }
      its(:lines)     { should == [27] }
      its(:log_file)  { should == 'spec/pass_spec.rb.log' }
      its(:worker)    { should == 1 }
      its(:exit_code) { should == 0 }
      its(:pid)       { should == 27490 }
    end

    context "when calling parse on a fail event line" do
      before do

        line = '["fail","spec/fail_spec.rb",[],"spec/fail_spec.rb.log",1,256,"#<Process::Status: pid 23318 exit 1>"]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a PassOrFailEvent }
      its(:type)      { should == 'fail' }
      its(:file)      { should == 'spec/fail_spec.rb' }
      its(:lines)     { should == [] }
      its(:log_file)  { should == 'spec/fail_spec.rb.log' }
      its(:worker)    { should == 1 }
      its(:exit_code) { should == 256 }
      its(:pid)       { should == 23318 }
    end

    context "when calling parse on an absorb event line" do
      before do
        line = '["absorb"]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_an Event }
      its(:type) { should == 'absorb' }
    end

    context "when calling parse on an unknown event type" do
      before do
        line = '["random"]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_an Event }
      its(:type) { should == 'random' }
    end

    context "when calling parse on a pass now fail event line" do
      before do
        line = '["pass_now_fail","spec/status_change_spec.rb",["fail","spec/status_change_spec.rb",[68],"spec/status_change_spec.rb.log",2,256,"#<Process::Status: pid 23819 exit 1>"]]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a StatusChangeEvent }
      its(:type)      { should == 'pass_now_fail' }
      its(:file)      { should == 'spec/status_change_spec.rb' }
      its(:event)     { should be_a PassOrFailEvent }

      context "and getting the inner event" do
        subject { @event.event }

        its(:type)      { should == 'fail' }
        its(:file)      { should == 'spec/status_change_spec.rb' }
        its(:log_file)  { should == 'spec/status_change_spec.rb.log' }
        its(:lines)     { should == [68] }
        its(:worker)    { should == 2 }
        its(:exit_code) { should == 256 }
        its(:pid)       { should == 23819 }
      end
    end

    context "when calling parse on a fail now pass event line" do
      before do
        line = '["fail_now_pass","spec/status_change_spec.rb",["pass","spec/status_change_spec.rb",[],"spec/status_change_spec.rb.log",1,0,"#<Process::Status: pid 677 exit 0>"]]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a StatusChangeEvent }
      its(:type)      { should == 'fail_now_pass' }
      its(:file)      { should == 'spec/status_change_spec.rb' }
      its(:event)     { should be_a PassOrFailEvent }

      context "and getting the inner event" do
        subject { @event.event }

        its(:type)      { should == 'pass' }
        its(:file)      { should == 'spec/status_change_spec.rb' }
        its(:log_file)  { should == 'spec/status_change_spec.rb.log' }
        its(:lines)     { should == [] }
        its(:worker)    { should == 1 }
        its(:exit_code) { should == 0 }
        its(:pid)       { should == 677 }
      end
    end

  end
end
