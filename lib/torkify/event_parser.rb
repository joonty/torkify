require 'json'
require_relative 'events/event'
require_relative 'events/test_event'
require_relative 'events/pass_or_fail_event'
require_relative 'events/status_change_event'

module Torkify
  class EventParser
    def parse(line)
      raw = JSON.load line
      event_from_data raw
    end

    protected
    def event_from_data(data)
      case data.first
      when 'test'
        TestEvent.new(*data)
      when /^(pass|fail)$/
        PassOrFailEvent.new(*data)
      when /^(pass_now_fail|fail_now_pass)$/
        StatusChangeEvent.new(data[0], data[1], event_from_data(data[2]))
      else
        Event.new(*data)
      end
    end
  end
end
