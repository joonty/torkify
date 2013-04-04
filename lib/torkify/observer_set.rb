require 'set'

module Torkify
  class ObserverSet
    def initialize(set = Set.new)
      @set = set
    end

    def dispatch(event)
      Torkify.logger.debug event.to_s
      message = "on_#{event.type}".to_sym
      @set.each do |observer|
        dispatch_each observer, message, event
      end
    end

    def |(enum)
      self.class.new(@set | enum)
    end

    def method_missing(method, *args, &blk)
      @set.send method, *args, &blk
    end

    def respond_to?(name, include_private = false)
      @set.respond_to? name, include_private
    end

    alias :+ :|
    alias :union :|

    private
    def dispatch_each(observer, message, event)
      method = observer.method(message)
      observer.send message, *method_args(method, event)
    rescue NameError
      Torkify.logger.warn { "No method #{message} defined on #{observer.inspect}" }
    rescue => e
      Torkify.logger.error { "Caught exception from #{observer} during ##{message}: #{e}" }
    end

    def method_args(method, event)
      dispatch_args = []
      unless method.arity === 0
        dispatch_args << event
      end
      dispatch_args
    end
  end
end
