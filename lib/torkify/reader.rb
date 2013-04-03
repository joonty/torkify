module Torkify
  require 'open3'

  class Reader
    # Open the tork command and initialize the streams.
    #
    # STDOUT is kept as the underlying stream, and this class can be used as
    # an IO-like object on STDOUT.
    #
    # A TorkError is raised if the command fails, and its message is whatever
    # has been written to the command's STDERR stream.
    def initialize(command = 'tork-remote tork-engine', run_in_dir = Dir.pwd)
      Dir.chdir(run_in_dir)

      _, @io, stderr, _ = Open3.popen3 command

      if @io.eof?
        raise TorkError, stderr.read.strip
      end
    end

    # Pass all unknown methods straight to the underlying IO object.
    #
    # This allows this class to be used in an IO like way.
    def method_missing(method, *args, &blk)
      @io.send(method, *args, &blk)
    end

    # Allow respond_to? to work with method_missing.
    def respond_to?(method, include_private = false)
      @io.respond_to? method, include_private
    end
  end
end
