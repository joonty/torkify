require 'json'
require_relative 'event'
require_relative 'test_event'
require_relative 'pass_or_fail_event'
require_relative 'status_change_event'
require_relative 'echo_event'

module Torkify::Event

  # Parse raw strings passed by tork into event objects.
  class Parser

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
        [ TestEvent.new(*data) ]
      when /^(pass|fail)$/
        [ PassOrFailEvent.new(*data) ]
      when /^(pass_now_fail|fail_now_pass)$/
        [ StatusChangeEvent.new(data[0], data[1], event_from_data(data[2]).first) ]
      when 'echo'
        parse_echo_event data
      else
        [ Event.new(data.first) ]
      end
    end

    def parse_echo_event(data)
      events = []
      events << EchoEvent.new(*data)
      event = event_from_echo data[1].first
      events << event if event
      events
    end

    def event_from_echo(action)
      if echo_aliases.has_key? action
        Event.new echo_aliases[action]
      elsif echo_aliases.has_value? action
        Event.new action
      else
        nil
      end
    end

    def echo_aliases
      { 'a' => 'run_all_test_files',
        ''  => 'run_test_files',
        't' => 'run_test_file',
        's' => 'stop_running_test_files',
        'k' => 'stop_running_test_files',
        'p' => 'rerun_passed_test_files',
        'f' => 'rerun_failed_test_files' }
    end
  end
end
