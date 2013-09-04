require_relative 'line_matcher'

module Torkify::Log
  class LogReader
    attr_reader :line

    def initialize(stream)
      @stream = stream
      @line = stream.readline
    end

    def forward
      self.line = stream.readline
      self
    end


    def matcher
      @matcher ||= LineMatcher.new(line)
    end

  protected
    attr_reader :stream
    attr_writer :line

    def line=(line)
      @line = line
      @matcher = nil
    end
  end

end
