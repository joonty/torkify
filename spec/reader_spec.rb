require 'spec_helper'
require 'torkify/reader'

module Torkify
  describe Reader do
    it "reads from the tork socket with IO#popen on creation" do
      IO.should_receive(:popen).with('tork-remote tork-engine', 'r+')
      Reader.new
    end

    it "reads from the passed command with IO#popen on creation" do
      command = 'this is a command'
      IO.should_receive(:popen).with(command, 'r+')
      Reader.new(command)
    end
  end
end
