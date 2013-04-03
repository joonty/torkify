require 'spec_helper'

module Torkify
  describe Conductor do
    before do
      @reader = double("Torkify::Reader")
      @observers = Torkify::ObserverSet.new
      @conductor = Conductor.new @reader, @observers
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
      it "should call each_line on reader" do
        @reader.should_receive(:each_line)
        @conductor.start
      end

      # TODO tidy this up
      context "with dummy input" do
        before do
          def @reader.each_line
            lines = ['["test","spec/status_change_event_spec.rb",[],"spec/status_change_event_spec.rb.log",0]']
            lines.each { |l| yield l }
          end
          @obs1 = double
          @obs2 = double
          @observers.add @obs1
          @observers.add @obs2
        end

        it "should notify each observer" do
          @obs1.should_receive(:on_test)
          @obs2.should_receive(:on_test)
          @conductor.start
        end
      end
    end
  end
end
