require 'spec_helper'

module Torkify
  describe Conductor do
    before do
      @reader = double("Torkify::Reader")
      @conductor = Conductor.new @reader
    end

    subject { @conductor }

    it { should respond_to :add_observer }
    it { should respond_to :observers }
    it { should respond_to :start }

    context "when an observer is added" do
      before do
        @observer = Object.new
        @conductor.add_observer @observer
      end

      subject { @conductor.observers.first }

      it { should equal @observer }
    end

    context "when start is called" do
      it "should call each_line on reader" do
        @reader.should_receive(:each_line)
        @conductor.start
      end
    end
  end
end
