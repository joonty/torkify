require 'spec_helper'

module Torkify
  describe Listener do
    before do
      Torkify::Reader.stub(:new)
      Torkify::Conductor.any_instance.stub(:start)
    end

    context "with default command and directory" do
      before do
        @command = 'tork-remote tork-engine'
        @dir = Dir.pwd
      end
      subject { Listener.new @command, @dir }

      it "should create a reader with those defaults" do
        Torkify::Reader.should_receive(:new).with @command, @dir
        subject.start
      end
    end

    context "with alternative command and directory" do
      before do
        @command = 'the command'
        @dir = 'the dir'
      end

      subject { Listener.new @command, @dir }

      it "should create a reader with the given parameters" do
        Torkify::Reader.should_receive(:new).with @command, @dir
        subject.start
      end
    end

    it { should respond_to :add_observer }

    context "after adding an observer" do
      before do
        @listener = Listener.new
      end

      subject { @listener.add_observer double }

      it { should be @listener }
    end
  end
end
