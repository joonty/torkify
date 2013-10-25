require_relative 'test_error'
require_relative 'log_reader'

module Torkify::Log
  module Error; end
  class ParserError < StandardError; end

  class Parser
    attr_reader :errors

    def initialize(stream)
      @reader = LogReader.new stream
      self.errors = []
    end

    def parse
      parse_log
      self
    rescue EOFError
      # noop
      self
    rescue Exception => e
      # Tag all exceptions with Torkify::Error
      e.extend Error
      raise e
    end

  protected
    attr_writer :errors
    attr_reader :reader

    def parse_log
      loop do
        if reader.matcher.ruby_error?
          parse_ruby_error
          if errors.empty?
            raise ParserError, "Failed to read error from log file"
          end
          break
        elsif tork_line_match = reader.matcher.tork_load_line
          @file_fallback = tork_line_match[1].strip + ".rb"
        elsif reader.matcher.test_error_or_failure?
          parse_errors_or_failures
        end
        reader.forward
      end
    end

    def parse_ruby_error
      line = reader.line
      if tork_match = reader.matcher.tork_error_line
        line.slice! tork_match[0]
      end
      matches = line.split(':')
      if matches.length >= 3
        self.errors << TestError.new(matches.shift.strip,
                                     matches.shift.strip,
                                     matches.join(':').strip.gsub("'", "`"),
                                     'E')
      end
    end

    def apply_file_from_matches(error, matches)
      if matches
        matches = matches.to_a
        matches.shift
        error.filename = matches.shift.strip
        error.lnum = matches.shift.strip
      end
    end

    def parse_errors_or_failures
      until reader.matcher.end_of_errors?
        if reader.matcher.test_error_or_failure?
          error = TestError.new(@file_fallback, '0', '', 'E')
          self.errors << error
        end

        matches = reader.matcher.error_description
        error.text << reader.line.gsub("'", "`")

        apply_file_from_matches error, matches
        reader.forward
      end

      errors.each do |err|
        if err.lnum == '0'
          matches = err.text.match(LineMatcher::PATTERNS['file_extraction'])
          apply_file_from_matches err, matches
        end
      end
    end

  end

end
