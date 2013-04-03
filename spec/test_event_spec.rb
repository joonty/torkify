require 'spec_helper'

module Torkify
  describe TestEvent do

    context "with typical seed data" do
      before do
        @type = 'test'
        @file = 'file'
        @lines = []
        @log_file = 'log_file'
        @worker = 1
        @file_event = TestEvent.new(@type, @file, @lines, @log_file, @worker)
      end

      subject { @file_event }

      its(:type)     { should == @type }
      its(:file)     { should == @file }
      its(:lines)    { should == @lines }
      its(:log_file) { should == @log_file }
      its(:worker)   { should == @worker }
    end
  end
end
