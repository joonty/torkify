module Torkify
  class TestEvent < Struct.new(:type, :file, :lines, :log_file, :worker)
    def to_s
      s = "#{type.upcase} #{file}"
      s += lines.any? ? " (lines #{lines.join(', ')})" : ''
    end
  end
end
