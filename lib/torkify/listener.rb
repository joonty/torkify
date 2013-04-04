module Torkify
  class Listener
    def initialize(command = 'tork-remote tork-engine', dir = Dir.pwd)
      @command = command
      @dir = dir
      @conductor = Conductor.new ObserverSet.new
    end

    def add_observer(observer)
      @conductor.observers << observer
      self
    end

    def start
      reader = Reader.new(@command, @dir)
      Torkify.logger.info { 'Started torkify listener' }
      @conductor.start reader
      Torkify.logger.info { 'Stopping torkify' }
    rescue Torkify::TorkError
      Torkify.logger.info { "Tork is not running" }
    end

    def start_loop
      loop do
        sleep 2
        start
      end
    rescue => e
      Torkify.logger.error { e }
    end

    def start_with_tork(command = 'tork')
      if fork
        start_loop
      else
        # Run tork in main process to keep stdin
        Torkify.logger.info { "Starting tork" }
        exec command
      end
    end
  end
end
