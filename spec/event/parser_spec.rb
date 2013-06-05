require 'spec_helper'
require 'torkify/event/parser'

module Torkify::Event
  describe Parser do
    before { @parser = Parser.new }

    context "when calling parse on a test event line with no numbers" do
      before do
        line = '["test","spec/reader_spec.rb",[],"spec/reader_spec.rb.log",3]'
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it { should be_a TestEvent }

      its(:file)     { should == 'spec/reader_spec.rb' }
      its(:lines)    { should == [] }
      its(:log_file) { should == 'spec/reader_spec.rb.log' }
      its(:worker)   { should == 3 }
    end

    context "when calling parse on a test event line with numbers" do
      before do
        line = '["test","spec/another_spec.rb",[20, 32, 41],"spec/another_spec.rb.log",6]'
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it { should be_a TestEvent }

      its(:file)     { should == 'spec/another_spec.rb' }
      its(:lines)    { should == [20, 32, 41] }
      its(:log_file) { should == 'spec/another_spec.rb.log' }
      its(:worker)   { should == 6 }
    end

    context "when calling parse on a pass event line" do
      before do
        line = '["pass","spec/pass_spec.rb",[27],"spec/pass_spec.rb.log",1,0,"#<Process::Status: pid 27490 exit 0>"]'
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

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
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

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
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it { should be_an BasicEvent }
      its(:type) { should == 'absorb' }
    end

    context "when calling parse on an unknown event type" do
      before do
        line = '["random"]'
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it { should be_an BasicEvent }
      its(:type) { should == 'random' }
    end

    context "when calling parse on a pass now fail event line" do
      before do
        line = '["pass_now_fail","spec/status_change_spec.rb",["fail","spec/status_change_spec.rb",[68],"spec/status_change_spec.rb.log",2,256,"#<Process::Status: pid 23819 exit 1>"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it { should be_a StatusChangeEvent }
      its(:type)      { should == 'pass_now_fail' }
      its(:file)      { should == 'spec/status_change_spec.rb' }
      its(:event)     { should be_a PassOrFailEvent }

      context "and getting the inner event" do
        subject { @event_list.first.event }

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
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it { should be_a StatusChangeEvent }
      its(:type)      { should == 'fail_now_pass' }
      its(:file)      { should == 'spec/status_change_spec.rb' }
      its(:event)     { should be_a PassOrFailEvent }

      context "and getting the inner event" do
        subject { @event_list.first.event }

        its(:type)      { should == 'pass' }
        its(:file)      { should == 'spec/status_change_spec.rb' }
        its(:log_file)  { should == 'spec/status_change_spec.rb.log' }
        its(:lines)     { should == [] }
        its(:worker)    { should == 1 }
        its(:exit_code) { should == 0 }
        its(:pid)       { should == 677 }
      end
    end

    context "when calling parse on an idle line for an idle event" do
      before do
        line = '["idle"]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 1 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an BasicEvent }

        its(:type) { should == 'idle' }
      end
    end

    context "when calling parse on an echo line for the idle event" do
      before do
        line = '["echo", ["idle"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 1 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
      end
    end

    context "when calling parse on an echo line for a run_all_test_files event" do
      before do
        line = '["echo",["run_all_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
        its(:args) { should == ['run_all_test_files'] }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'run_all_test_files' }
      end
    end

    context "when calling parse on an echo line for the run_all_test_files user command" do
      before do
        line = '["echo", ["a"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'run_all_test_files' }
      end
    end

    context "when calling parse on an echo line for a run_test_file event" do
      before do
        line = '["echo",["run_test_file", "path/to/file.rb"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
        its(:args) { should == ['run_test_file', 'path/to/file.rb'] }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'run_test_file' }
      end
    end

    context "when calling parse on an echo line for the run_test_file user command" do
      before do
        line = '["echo", ["t", "path/to/file.rb"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'run_test_file' }
      end
    end

    context "when calling parse on an echo line for a stop_running_test_files event" do
      before do
        line = '["echo",["stop_running_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
        its(:args) { should == ['stop_running_test_files'] }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'stop_running_test_files' }
      end
    end

    context "when calling parse on an echo line for the run_test_file user command" do
      before do
        line = '["echo", ["s"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'stop_running_test_files' }
      end
    end

    context "when calling parse on an echo line for a rerun_passed_test_files event" do
      before do
        line = '["echo",["rerun_passed_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
        its(:args) { should == ['rerun_passed_test_files'] }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'rerun_passed_test_files' }
      end
    end

    context "when calling parse on an echo line for the rerun_passed_test_files user command" do
      before do
        line = '["echo", ["p"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'rerun_passed_test_files' }
      end
    end

    context "when calling parse on an echo line for a rerun_failed_test_files event" do
      before do
        line = '["echo",["rerun_failed_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
        its(:args) { should == ['rerun_failed_test_files'] }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'rerun_failed_test_files' }
      end
    end

    context "when calling parse on an echo line for the rerun_failed_test_files user command" do
      before do
        line = '["echo", ["f"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      its(:length) { should == 2 }

      context "the first event" do
        subject { @event_list.first }

        it { should be_an EchoEvent }

        its(:type) { should == 'echo' }
      end

      context "the second event" do
        subject { @event_list[1] }

        it { should be_an BasicEvent }

        its(:type) { should == 'rerun_failed_test_files' }
      end
    end
  end
end
