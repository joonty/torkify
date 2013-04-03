module Torkify
  class Conductor
    attr_reader :observers

    def initialize(reader)
      @reader = reader
      @observers = []
    end

    def add_observer(observer)
      @observers << observer
    end

    def start
    end
  end
end
