require_relative 'message'

module Torkify::Event

  # Event used when all tests have finished running.
  #
  # The time method gives the approximate time in seconds that the tests
  # took to run.
  class RanAllTestFilesEvent < Struct.new(:type, :passed, :failed)
    include Message

    def initialize(type, passed = [], failed = [])
      @created = Time.now.to_f
      super
    end

    def stop!
      if @time.nil?
        @time = Time.now.to_f - @created
      end
      self
    end

    def time
      stop!
      @time
    end
  end
end

