
module Torkify::Log
  class LineMatcher
    PATTERNS = {
      'tork_load_line'        => /^Loaded suite tork[^\s]+\s(.+)/,
      'error_description'     => /^[\s#]*([^:]+):([0-9]+):in/,
      'file_extraction'       => /\[([^:]+):([0-9]+)\]/m,
      'tork_error_line'       => /^.+tork\/master\.rb:[0-9]+:in [^:]+:\s/,
      'test_error_or_failure' => /^(\s+[0-9]+\)|Failure(?!s)|Error)/,
      'test_summary'          => /^([0-9]+\s[a-z]+,)+/,
      'finished_line'         => /^Finished/
    }

    def initialize(line)
      self.line = line
    end

    PATTERNS.each do |name, reg|
      define_method("#{name}?") { !(line =~ PATTERNS[name]).nil? }
      define_method("#{name}")  { PATTERNS[name].match(line) }
    end

    def end_of_errors?
      test_summary? || finished_line?
    end

    alias :ruby_error :error_description
    alias :ruby_error? :error_description?

  protected
    attr_accessor :line
  end
end
