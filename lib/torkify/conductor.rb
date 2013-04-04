require_relative 'events/event'
require_relative 'event_parser'

module Torkify
  class Conductor
    attr_accessor :observers

    def initialize(observers)
      @observers = observers
    end

    def start(reader)
      dispatch Event.new 'start'
      parser = EventParser.new
        reader.each_line do |line|
          event = parser.parse line
          dispatch event
        end
      dispatch Event.new 'stop'
    end

    protected
    def dispatch(event)
      @observers.dispatch(event)
    end
  end
end
