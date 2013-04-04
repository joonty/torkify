require_relative 'event_message'

module Torkify
  # Event used when a test is started.
  #
  # This is currently only one type: 'test'
  class TestEvent < Struct.new(:type, :file, :lines, :log_file, :worker)
    include EventMessage

    def to_s
      s = "#{type.upcase} #{file}"
      s += lines.any? ? " (lines #{lines.join(', ')})" : ''
    end
  end
end
