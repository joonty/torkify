module Torkify
  class Conductor
    attr_accessor :observers

    def initialize(reader, observers)
      @reader = reader
      @observers = observers
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
      puts "Event: #{event.inspect}"
      @observers.dispatch(event)
    end
  end
end
