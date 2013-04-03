module Torkify
  require 'set'

  class ObserverSet
    def initialize
      @set = Set.new
    end

    def dispatch(event)
      @set.each do |observer|
        begin
          message = "on_#{event.type}"
          observer.send message.to_sym, event
        rescue NoMethodError => e
          puts "Warning: #{e.message}"
        end
      end
    end

    def method_missing(method, *args, &blk)
      @set.send method, *args, &blk
    end

    def respond_to?(name, include_private = false)
      @set.respond_to? name, include_private
    end
  end
end
