require_relative 'event/basic_event'
require_relative 'event/parser'
require_relative 'event/dispatcher'

module Torkify

  # Connect the socket reader and observers, and dispatch events.
  class Conductor
    # Create with a set of observers.
    def initialize(observers)
      @dispatcher = Event::Dispatcher.new observers
    end

    def observers
      @dispatcher.observers
    end

    def observers=(*args)
      @dispatcher.send :observers=, *args
    end

    # Start reading from the reader, which is an IO-like object.
    #
    # Parse each line and dispatch it as an event object to all observers.
    def start(reader)
      dispatch Event::BasicEvent.new 'startup'
      parser = Event::Parser.new

      while line = reader.gets
        Torkify.logger.debug { "Read line: #{line}" }
        events = parser.parse line
        dispatch(*events)
      end

      dispatch Event::BasicEvent.new 'shutdown'
    end

    protected
    def dispatch(*events)
      events.each { |event| @dispatcher.dispatch(event) }
    end
  end
end
