require 'spec_helper'

module Torkify
  describe Conductor do
    before do
      @reader = double
      @observers = Torkify::ObserverSet.new
      @conductor = Conductor.new @observers
    end

    subject { @conductor }

    it { should respond_to :observers }
    it { should respond_to :start }

    its(:observers) { should equal @observers }

    context "when an observer is added" do
      before do
        @observer = Object.new
        @conductor.observers.add @observer
      end

      subject { @conductor.observers.first }

      it { should equal @observer }
    end

    context "when start is called" do
      before do
        @conductor.observers += [double, double]
        @conductor.observers.each do |o|
          o.should_receive(:on_start)
          o.should_receive(:on_stop)
        end
      end

      it "should call start and stop on each observer and each_line on reader" do
        @reader.should_receive(:each_line)
        @conductor.start @reader
      end
    end

    context "when start is called with dummy input" do
      before do
        line = '["test","spec/status_change_event_spec.rb",[],"spec/status_change_event_spec.rb.log",0]'
        @reader.should_receive(:each_line).and_yield(line)
        @conductor.observers += [double, double]
      end

      it "should notify each observer about the test event" do
        @conductor.observers.each do |o|
          o.should_receive(:on_start)
          o.should_receive(:on_test)
          o.should_receive(:on_stop)
        end
        @conductor.start @reader
      end
    end
  end
end
