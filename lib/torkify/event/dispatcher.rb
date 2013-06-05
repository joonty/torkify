module Torkify::Event
  class Dispatcher
    def initialize(observers)
      @observers = observers
    end

    def dispatch(event)
      observers.each { |o| o.send event.message, event }
    end

  protected
    attr_reader :observers
  end
end
