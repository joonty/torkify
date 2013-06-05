module Torkify::Event
  class Dispatcher
    attr_accessor :observers

    def initialize(observers)
      @observers = observers
    end

    def dispatch(event)
      observers.each do |o|
        begin
          observer_dispatch(o, event)
        rescue => e
          Torkify.logger.error { "Caught exception from observer #{o.inspect} during ##{event.message}: #{e}" }
        end
      end
    end

  protected
    def observer_dispatch(observer, event)
      message = event.message
      observer_method = observer.method message
      send_args = arguments_by_arity observer_method.arity, event
      observer_send_and_trap observer, message, send_args
    rescue NameError
      send_args = arguments_by_arity 1, event
      observer_send_and_trap observer, message, send_args
    end

    def observer_send_and_trap(observer, message, args)
      observer.send message, *args
    rescue NoMethodError
      Torkify.logger.debug { "No method #{message} defined on #{observer.inspect}" }
    end

    def arguments_by_arity(method_arity, event)
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
