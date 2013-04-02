require 'spec_helper'
require 'torkify/pass_or_fail_event'

module Torkify
  describe PassOrFailEvent do

    context "with typical seed data" do
      before do
        @file = 'file'
        @lines = []
        @log_file = 'log_file'
        @worker = 1
        @exit_code = 2
        @exit_info = 'exit info'

        @file_event = PassOrFailEvent.new(@file, @lines, @log_file, @worker, @exit_code, @exit_info)
      end

      its(:file) { @file }
      its(:lines) { @lines }
      its(:log_file) { @log_file }
      its(:worker) { @worker }
      its(:exit_code) { @exit_code }
      its(:exit_info) { @exit_info }
    end
  end
end
