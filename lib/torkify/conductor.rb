require_relative 'event/event'
require_relative 'event/parser'

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
      dispatch Event::Event.new 'startup'
      parser = Event::Parser.new

      while line = reader.gets
        Torkify.logger.debug { "Read line: #{line}" }
        events = parser.parse line
        dispatch(*events)
      end

      dispatch Event::Event.new 'shutdown'
    end

    protected
    def dispatch(*events)
      events.each { |e| @observers.dispatch(e) }
    end
  end
end
