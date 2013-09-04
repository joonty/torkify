require_relative 'message'

module Torkify::Event

  # Event used for test passes or failures.
  #
  # Types:
  #
  #  - pass
  #  - fail
  class PassOrFailEvent < Struct.new(:type, :file, :lines, :log_file, :worker, :exit_code, :exit_info)
    include Message

    # Get the PID from the exit info.
    def pid
      matched = exit_info.scan(/pid ([0-9]+)/).first
      matched.first.to_i if matched
    end

    def errors
      @errors ||= parse_errors_from_log
    end

    def to_s
      s = "#{type.upcase} #{file}"
      s += lines.any? ? " (lines #{lines.join(', ')})" : ''
    end

  protected
    def parse_errors_from_log
      log = File.open log_file
      parser = Torkify::Log::Parser.new log
      parser.parse
      parser.errors
    end
  end
end
