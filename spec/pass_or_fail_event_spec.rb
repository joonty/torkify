require 'spec_helper'

module Torkify
  describe PassOrFailEvent do

    context "with typical seed data" do
      before do
        @type = 'pass'
        @file = 'file'
        @lines = []
        @log_file = 'log_file'
        @worker = 1
        @exit_code = 2
        @exit_info = 'exit info'
      end

      subject { @event = PassOrFailEvent.new @type,
                                             @file,
                                             @lines,
                                             @log_file,
                                             @worker,
                                             @exit_code,
                                             @exit_info }

      its(:type)      { should == @type }
      its(:file)      { should == @file }
      its(:lines)     { should == @lines }
      its(:log_file)  { should == @log_file }
      its(:worker)    { should == @worker }
      its(:exit_code) { should == @exit_code }
      its(:exit_info) { should == @exit_info }
      its(:to_s)      { should == "PASS file" }

      context "and line numbers" do
        before do
          @lines = [1, 14, 23]
        end

        its(:to_s)      { should == "PASS file (lines 1, 14, 23)" }
      end
    end

    context "with a process status string" do
      before do
        @event = PassOrFailEvent.new(*(1..6),
                                     '#<Process::Status: pid 18228 exit 0>')
      end

      subject { @event.pid }

      it { should == 18228 }
    end
  end
end
