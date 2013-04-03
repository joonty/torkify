require 'spec_helper'
require 'torkify/test_event'

module Torkify
  describe TestEvent do

    context "with typical seed data" do
      before do
        @type = 'test'
        @file = 'file'
        @lines = []
        @log_file = 'log_file'
        @worker = 1
        @file_event = TestEvent.new(@test, @lines, @log_file, @worker)
      end

      its(:type) { @test }
      its(:file) { @file }
      its(:lines) { @lines }
      its(:log_file) { @log_file }
      its(:worker) { @worker }
    end
  end
end
