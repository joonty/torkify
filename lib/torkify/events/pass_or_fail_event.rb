require_relative 'event_message'

module Torkify

  # Event used for test passes or failures.
  #
  # Types:
  #
  #  - pass
  #  - fail
  class PassOrFailEvent < Struct.new(:type, :file, :lines, :log_file, :worker, :exit_code, :exit_info)
    include EventMessage

    # Get the PID from the exit info.
    def pid
      matched = exit_info.scan(/pid ([0-9]+)/).first
      matched.first.to_i if matched
    end

    def to_s
      s = "#{type.upcase} #{file}"
      s += lines.any? ? " (lines #{lines.join(', ')})" : ''
    end
  end
end
