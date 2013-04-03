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
      parser = EventParser.new
      @reader.each_line do |line|
        event = parser.parse line
        dispatch event
      end
    end

    protected
    def dispatch(event)
      @observers.each { |o| o.send event.type.to_sym, event }
    end
  end
end
