require 'spec_helper'
require 'torkify/conductor'
require 'torkify/reader'

module Torkify
  describe Conductor do
    before do
      @conductor = Conductor.new double("Torkify::Reader")
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
  end
end
