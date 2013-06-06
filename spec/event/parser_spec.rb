require 'spec_helper'
require 'torkify/event/parser'

module Torkify::Event
  shared_examples "a basic event" do |type|
    it { should be_an BasicEvent }
    its(:type) { should == type }
  end

  shared_examples "an echo event" do |args|
    it { should be_an EchoEvent }
    its(:type) { should == 'echo' }
    its(:args) { should == args }
  end

  shared_examples "an echo event and sub event" do |type, echo_args = nil|
    its(:length) { should == 2 }

    context "the first event" do
      subject { @event_list.first }

      it_behaves_like "an echo event", (echo_args || [type])
    end

    context "the second event" do
      subject { @event_list[1] }

      it_behaves_like "a basic event", type
    end
  end

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

      it_behaves_like "a basic event", 'absorb'
    end

    context "when calling parse on an unknown event type" do
      before do
        line = '["random"]'
        @event_list = @parser.parse line
      end

      subject { @event_list.first }

      it_behaves_like "a basic event", 'random'
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

        it_behaves_like "a basic event", 'idle'
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

        it_behaves_like "an echo event", ['idle']
      end
    end

    context "when calling parse on an echo line for the run_test_files command" do
      context "with no arguments" do
        before do
          line = '["echo", ["run_test_files", []]]'
          @event_list = @parser.parse line
        end

        subject { @event_list }

        its(:length) { should == 1 }

        context "the first event" do
          subject { @event_list.first }

          it_behaves_like "an echo event", ['run_test_files', []]
        end
      end

      context "with files as arguments" do
        before do
          line = '["echo", ["run_test_files", ["path/to/file1.rb", "path/to/file2.rb"]]]'
          @event_list = @parser.parse line
        end

        subject { @event_list }

        it_behaves_like "an echo event and sub event",
                        'run_test_files',
                        ["run_test_files", ["path/to/file1.rb", "path/to/file2.rb"]]
      end
    end

    context "when calling parse on an echo line for the run_test_file command" do
      before do
        line = '["echo", ["run_test_file", "path/to/file.rb"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      it_behaves_like "an echo event and sub event", 'run_test_file', ['run_test_file', 'path/to/file.rb']
    end

    context "when calling parse on an echo line for the run_test_file command" do
      before do
        line = '["echo", ["stop_running_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      it_behaves_like "an echo event and sub event", 'stop_running_test_files'
    end

    context "when calling parse on an echo line for the rerun_passed_test_files command" do
      before do
        line = '["echo", ["rerun_passed_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      it_behaves_like "an echo event and sub event", 'rerun_passed_test_files'
    end

    context "when calling parse on an echo line for a rerun_failed_test_files command" do
      before do
        line = '["echo",["rerun_failed_test_files"]]'
        @event_list = @parser.parse line
      end

      subject { @event_list }

      it_behaves_like "an echo event and sub event", 'rerun_failed_test_files'
    end
  end
end
