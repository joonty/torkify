module Torkify
  require 'set'

  class ObserverSet
    def initialize(set = Set.new)
      @set = set
    end

    def dispatch(event)
      Torkify.logger.debug "Received event: #{event.inspect}"
      @set.each do |observer|
        begin
          message = "on_#{event.type}"
          observer.send message.to_sym, event
        rescue NoMethodError => e
          Torkify.logger.warn { e.message }
        end
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
  end
end
