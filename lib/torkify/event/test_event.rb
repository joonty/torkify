require_relative 'message'

module Torkify::Event

  # Event used when a test is started.
  #
  # This is currently only one type: 'test'
  class TestEvent < Struct.new(:type, :file, :lines, :log_file, :worker)
    include Message

    def to_s
      s = "#{type.upcase} #{file}"
      s += lines.any? ? " (lines #{lines.join(', ')})" : ''
    end
  end
end
