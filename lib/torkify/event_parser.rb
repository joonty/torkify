require 'json'
require_relative 'events/event'
require_relative 'events/test_event'
require_relative 'events/pass_or_fail_event'
require_relative 'events/status_change_event'

module Torkify

  # Parse raw strings passed by tork into event objects.
  class EventParser

    # Parse a raw string and return an object based on the event type.
    #
    # E.g. a raw string like:
    # > '["test","spec/reader_spec.rb",[],"spec/reader_spec.rb.log",3]'
    def parse(line)
      raw = JSON.load line
      event_from_data raw
    end

    protected
    # Create an event object from the array of data.
    def event_from_data(data)
      case data.first
      when 'test'
        TestEvent.new(*data)
      when /^(pass|fail)$/
        PassOrFailEvent.new(*data)
      when /^(pass_now_fail|fail_now_pass)$/
        StatusChangeEvent.new(data[0], data[1], event_from_data(data[2]))
      else
        Event.new(data.first)
      end
    end
  end
end
