require 'json'
require_relative 'basic_event'
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
        [ BasicEvent.new(data.first) ]
      end
    end

    def parse_echo_event(data)
      events = [ EchoEvent.new(*data) ]
      event = event_from_echo(*data[1])
      events << event if event
      events
    end

    def event_from_echo(action, action_args = nil)
      if echo_commands_requiring_args.include? action
        return if action_args.nil? || action_args.empty?
      end
      if known_echo_commands.include? action
        BasicEvent.new action
      end
    end

    def known_echo_commands
      [ 'run_all_test_files',
        'run_test_files',
        'run_test_file',
        'stop_running_test_files',
        'stop_running_test_files',
        'rerun_passed_test_files',
        'rerun_failed_test_files' ]
    end

    def echo_commands_requiring_args
      [ 'run_test_files',
        'run_test_file' ]
    end
  end
end
