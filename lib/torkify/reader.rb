require 'open3'
require_relative 'exceptions'

module Torkify
  class Reader
    # Open the tork command and initialize the streams.
    #
    # STDOUT is kept as the underlying stream, and this class can be used as
    # an IO-like object on STDOUT.
    #
    # A TorkError is raised if the command fails, and its message is whatever
    # has been written to the command's STDERR stream.
    def initialize(command = 'tork-remote tork-engine', run_in_dir = Dir.pwd)
      Dir.chdir(run_in_dir) do
        self.in, self.out, self.err, self.thread = Open3.popen3 command

        if out.eof?
          raise TorkError, err.read.strip
        end
      end
    end

    # Pass all unknown methods straight to the underlying IO object.
    #
    # This allows this class to be used in an IO like way.
    def method_missing(method, *args, &blk)
      out.send method, *args, &blk
    end

    # Allow respond_to? to work with method_missing.
    def respond_to?(method, include_private = false)
      out.respond_to? method, include_private
    end
  protected
    attr_accessor :in, :out, :err, :thread
  end
end
