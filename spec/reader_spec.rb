require 'spec_helper'
require 'torkify/reader'

module Torkify
  describe Reader do
    context "with dummy command" do
      before { @reader = Reader.new 'echo' }
      subject { @reader}

      it { should respond_to :readline  }
      it { should respond_to :each_line }
      it { should respond_to :pos       }
    end

    context "with echo command" do
      before { @reader = Reader.new 'echo "Line 1\nLine 2"' }

      context "first line" do
        subject { @reader.readline }
        it { should == "Line 1\n" }
      end

      context "second line" do
        before { @reader.readline }
        subject { @reader.readline }

        it { should == "Line 2\n" }
      end

      context "each over line" do
        before do
          @output = ''
          @reader.each_line { |line| @output += line }
        end

        subject { @output }

        it { should == "Line 1\nLine 2\n" }
      end
    end

    context "with command that writes to standard error" do
      it "should raise TorkError" do
        err = 'Command error'
        expect { Reader.new("echo '#{err}' >&2") }.to raise_exception(TorkError, err)
      end
    end
  end
end
