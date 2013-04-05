require_relative 'events/event'
require_relative 'event_parser'

module Torkify

  # Connect the socket reader and observers, and dispatch events.
  class Conductor
    attr_accessor :observers

    # Create with a set of observers.
    def initialize(observers)
      @observers = observers
    end

    # Start reading from the reader, which is an IO-like object.
    #
    # Parse each line and dispatch it as an event object to all observers.
    def start(reader)
      dispatch Event.new 'startup'
      parser = EventParser.new
        reader.each_line do |line|
          event = parser.parse line
          dispatch event
        end
      dispatch Event.new 'shutdown'
    end

    protected
    def dispatch(event)
      @observers.dispatch(event)
    end
  end
end
