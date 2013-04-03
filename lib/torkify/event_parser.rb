module Torkify
  require 'json'

  class EventParser
    def parse(line)
      raw = JSON.load line
      klazz = class_from_type raw.first
      klazz.new(*raw)
    end

    protected
    def class_from_type(type)
      case type
      when 'test'
        TestEvent
      when 'pass' || 'fail'
        PassOrFailEvent
      end
    end
  end
end
