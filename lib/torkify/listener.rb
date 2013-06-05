require_relative 'conductor'
require_relative 'reader'
require_relative 'exceptions'

module Torkify
  class Listener
    # Create a torkify listener with optional command and directory specified.
    #
    # The command is what's used to start the tork remote engine. The
    # directory is where the command will be executed.
    def initialize(command = 'tork-remote tork-engine', dir = Dir.pwd)
      @command = command
      @dir = dir
      @conductor = Conductor.new Set.new
    end

    # Add an observer object to be notified of tork events.
    #
    # The object will be notified of events if it contains the following
    # methods:
    #
    #  - on_startup(event)       - when torkify starts
    #  - on_shutdown(event)      - when torkify shuts down
    #  - on_test(event)          - when a test is started
    #  - on_pass(event)          - when a test passes
    #  - on_fail(event)          - when a test fails
    #  - on_fail_now_pass(event) - when a previously failed test passes
    #  - on_pass_now_fail(event) - when a previously passed test fails
    #  - on_absorb(event)        - when tork reabsorbs overhead
    #
    # It doesn't have to inherit from a particular type, just define the
    # method. The argument is optional, and in each case it gives an event.
    def add_observer(observer)
      @conductor.observers << observer
      self
    end

    # Start the torkify listener and dispatch events to observers.
    #
    # This runs once, and connects to an existing tork process. If tork
    # stops running then torkify will shut down.
    #
    # For continuous listening use #start_loop() instead.
    #
    # To start tork as well, use #start_with_tork().
    def start
      reader = Reader.new(@command, @dir)
      Torkify.logger.info { 'Started torkify listener' }
      @conductor.start reader
      Torkify.logger.info { 'Stopping torkify' }
      self
    rescue Torkify::TorkError
      Torkify.logger.info { "Tork is not running" }
      self
    end

    # Start the torkify listener and loop until it connects to a tork process.
    #
    # If the tork process stops, it will keep looping until another starts.
    #
    # Calls #start().
    def start_loop
      loop do
        sleep 2
        start
      end
    rescue => e
      Torkify.logger.error { e }
    end

    # Start the torkify listener and tork itself.
    #
    # It forks the current process and runs torkify as the child. It then
    # runs the tork CLI as the main process, allowing for stdin to be passed to tork.
    #
    # Calls #start_loop().
    def start_with_tork(command = 'tork')
      load_tork

      if fork
        start_loop
      else
        # Run tork in main process to keep stdin
        Torkify.logger.info { "Starting tork" }

        $0 = File.basename Dir.pwd
        Tork::CLIApp.new.loop
      end
    end

    def load_tork
      require 'tork/config'
      require 'tork/cliapp'
    rescue LoadError
      Torkify.logger.fatal { "Could not load tork: try running `gem install tork`" }
      raise
    end
  end
end
