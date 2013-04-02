require 'spec_helper'
require 'torkify/file_event'

module Torkify
  describe FileEvent do

    context "with typical seed data" do
      before do
        @file = 'file'
        @lines = []
        @log_file = 'log_file'
        @worker = 1
        @file_event = FileEvent.new(@file, @lines, @log_file, @worker)
      end

      its(:file) { @file }
      its(:lines) { @lines }
      its(:log_file) { @log_file }
      its(:worker) { @worker }
    end
  end
end
