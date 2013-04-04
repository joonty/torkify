require 'spec_helper'

module Torkify
  describe Event do
    context "when type is absorb" do
      before do
        @event = Event.new('absorb')
      end

      subject { @event }

      its(:type) { should == 'absorb' }
      its(:to_s) { should == 'absorb' }
    end
  end
end
