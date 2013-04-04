module Torkify
  class Conductor
    attr_accessor :observers

    def initialize(reader, observers)
      @reader = reader
      @observers = observers
    end

    def start
      Torkify.logger.info { 'Started torkify' }
      dispatch Event.new 'start'
      parser = EventParser.new
      @reader.each_line do |line|
        event = parser.parse line
        dispatch event
      end
      dispatch Event.new 'stop'
      Torkify.logger.info { 'Stopped torkify' }
    end

    protected
    def dispatch(event)
      @observers.dispatch(event)
    end
  end
end
