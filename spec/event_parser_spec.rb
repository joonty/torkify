require 'spec_helper'
require 'torkify/event_parser'
require 'torkify/test_event'

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
        line = '["pass","spec/event_parser_spec.rb",[27],"spec/event_parser_spec.rb.log",1,0,"#<Process::Status: pid 27490 exit 0>"]'
        @event = @parser.parse line
      end

      subject { @event }

      it { should be_a PassOrFailEvent }
      its(:file)      { should == 'spec/event_parser_spec.rb' }
      its(:lines)     { should == [27] }
      its(:log_file)  { should == 'spec/event_parser_spec.rb.log' }
      its(:worker)    { should == 1 }
      its(:exit_code) { should == 0 }
      its(:pid)       { should == 27490 }
    end
  end
end
