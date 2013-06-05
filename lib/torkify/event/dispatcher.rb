require_relative 'ran_all_test_files_event'

module Torkify::Event
  class Dispatcher
    attr_accessor :observers

    def initialize(observers)
      @observers = observers
    end

    def dispatch(event)
      observers.each do |o|
        ObserverEventDispatcher.new(o, event).dispatch
      end
      act_if_required event
    end

  protected

    def act_if_required(event)
      case event.type
      when :run_all_test_files
        @ran_all_tests_event = RanAllTestFilesEvent.new(:ran_all_test_files, [], [])
      when :pass
        if @ran_all_tests_event
          @ran_all_tests_event.passed << event
        end
      when :fail
        if @ran_all_tests_event
          @ran_all_tests_event.failed << event
        end
      when :idle
        if @ran_all_tests_event
          @ran_all_tests_event.stop!
          dispatch @ran_all_tests_event
          @ran_all_tests_event = nil
        end
      end

    end

    class ObserverEventDispatcher
      def initialize(observer, event)
        @observer = observer
        @event = event
      end

      def dispatch
        dispatch_and_rescue
      rescue => e
        Torkify.logger.error { "Caught exception from observer #{o.inspect} during ##{event.message}: #{e}" }
      end

    protected
      attr_reader :observer, :event

      def dispatch_and_rescue
        send_and_trap arguments_for_event_message
      rescue NameError
        send_args = arguments_by_arity 1
        send_and_trap send_args
      end

      def send_and_trap(args)
        observer.send event.message, *args
      rescue NoMethodError
        Torkify.logger.debug { "No method #{message} defined on #{observer.inspect}" }
      end

      def arguments_for_event_message
        arguments_by_arity observer.method(event.message).arity
      end

      def arguments_by_arity(method_arity)
        case method_arity
        when 0
          []
        when -1, 1
          [event]
        else
          [event].fill(nil, 1, method_arity - 1)
        end
      end
    end

  end
end
