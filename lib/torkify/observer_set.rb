require 'set'

module Torkify
  # Wrapper around a Set class, that adds a dispatch method.
  #
  # Dispatch sends an event that calls a method on all observers.
  class ObserverSet
    def initialize(set = Set.new)
      @set = set
    end

    # Call a method on all observers, depending on the event type.
    #
    # The method is the event type prefixed with "on_". E.g. 'test' would be
    # 'on_test'.
    def dispatch(event)
      Torkify.logger.debug event.to_s
      message = "on_#{event.type}".to_sym
      @set.each do |observer|
        dispatch_each observer, message, event
      end
    end

    # Don't return a Set, return an ObserverSet.
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
    # Send the messages to a given observer, with the event object.
    def dispatch_each(observer, message, event)
      method = observer.method(message)
      observer.send message, *method_args(method, event)
    rescue NameError
      Torkify.logger.warn { "No method #{message} defined on #{observer.inspect}" }
    rescue => e
      Torkify.logger.error { "Caught exception from #{observer} during ##{message}: #{e}" }
    end

    # Determine whether to include the event in the arguments.
    #
    # The arity of the obsever's method is checked to see whether an
    # argument is received or not.
    def method_args(method, event)
      dispatch_args = []
      unless method.arity === 0
        dispatch_args << event
      end
      dispatch_args
    end
  end
end
