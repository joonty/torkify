require 'json'
require_relative 'events/test_event'
require_relative 'events/pass_or_fail_event'
require_relative 'events/event'

module Torkify
  class EventParser
    def parse(line)
      raw = JSON.load line
      event_from_data raw
    end

    protected
    def event_from_data(data)
      klazz = class_from_type data.first
      klazz.new(*data)
    end

    def class_from_type(type)
      case type
      when 'test'
        TestEvent
      when /(pass|fail)/
        PassOrFailEvent
      else
        Event
      end
    end
  end
end
