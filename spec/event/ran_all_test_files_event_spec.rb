require 'spec_helper'
require 'torkify/event/ran_all_test_files_event'

module Torkify::Event
  describe RanAllTestFilesEvent do
    context "with no sub events" do
      subject { RanAllTestFilesEvent.new :all_tests_run }

      its(:type)    { should == :all_tests_run }
      its(:message) { should == :on_all_tests_run }
      its(:passed)  { should == [] }
      its(:failed)  { should == [] }
      its(:time)  { should > 0.0 }
    end

    context "with passed and failed events" do
      let(:passed) { [mock, mock] }
      let(:failed) { [mock, mock] }
      subject { RanAllTestFilesEvent.new :all_tests_run, passed, failed }

      its(:type)    { should == :all_tests_run }
      its(:message) { should == :on_all_tests_run }
      its(:passed)  { should == passed }
      its(:failed)  { should == failed }
      its(:time)    { should > 0.0 }
    end

    context "after sleeping" do
      let(:event) { RanAllTestFilesEvent.new :all_tests_run }

      before do
        event
        sleep 0.3
      end

      subject { event }

      its(:time) { should > 0.3 }
    end
  end
end

