module Torkify
  class Listener
    def initialize(command = 'tork-remote tork-engine', dir = Dir.pwd)
      Torkify.logger.info { 'Started torkify' }
      @command = command
      @dir = dir
      @conductor = Conductor.new ObserverSet.new
    end

    def add_observer(observer)
      @conductor.observers << observer
      self
    end

    def start
      @conductor.start Reader.new(@command, @dir)
      Torkify.logger.info { 'Stopping torkify' }
    end

    def start_with_tork
      if fork
        sleep 5
        start
      else
        # Run tork in main process to keep stdin
        Torkify.logger.info { "Starting tork" }
        exec 'tork'
      end
    end
  end
end
