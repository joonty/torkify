module Torkify
  require 'stringio'
  require 'open3'

  class Reader
    def initialize(command = 'tork-remote tork-engine', run_in_dir = Dir.pwd)
      Dir.chdir(run_in_dir)

      _, @io, stderr, _ = Open3.popen3 command

      if @io.eof?
        raise TorkError, stderr.read.strip
      end
    end

    def method_missing(method, *args, &blk)
      @io.send(method, *args, &blk)
    end

    def respond_to?(method, include_private = false)
      @io.respond_to? method, include_private
    end
  end
end
