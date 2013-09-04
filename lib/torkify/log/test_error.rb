module Torkify::Log
  class TestError < Struct.new(:filename, :lnum, :text, :type)
    def clean_text
      text.strip
    end
  end
end
