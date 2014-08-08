module Torkify::Log
  class TestError
    attr_accessor :filename, :lnum, :text, :type

    def initialize(filename, lnum, text, type)
      @filename = filename
      @lnum     = lnum
      @text     = text
      @type     = type
    end

    def clean_text
      text.strip
    end
  end
end
