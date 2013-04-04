require 'spec_helper'
require 'torkify/events/test_event'

module Torkify
  describe TestEvent do

    context "with typical seed data" do
      before do
        @type = 'test'
        @file = 'file'
        @lines = []
        @log_file = 'log_file'
        @worker = 1
      end

      subject { TestEvent.new(@type, @file, @lines, @log_file, @worker) }

      its(:type)     { should == @type }
      its(:file)     { should == @file }
      its(:lines)    { should == @lines }
      its(:log_file) { should == @log_file }
      its(:worker)   { should == @worker }
      its(:to_s)     { should == 'TEST file' }

      context "with line numbers" do
        before { @lines = [1, 5, 12] }
        its(:to_s)   { should == 'TEST file (lines 1, 5, 12)' }
      end
    end
  end
end
