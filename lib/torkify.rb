require "torkify/version"

# Listen to tork events and execute ruby code when they happen.
#
# E.g.
#
#   listener = Torkify.listener
#   class Observer
#     def on_pass(event)
#       puts event.to_s
#     end
#   end
#   listener.add_observer Observer.new
#   listener.start
#   # or listener.start_loop
#   # or listener.start_with_tork
module Torkify

  # Create a listener object and load all required files.
  def self.listener(*args)
    load_files
    Listener.new(*args)
  end

  # Create a logger object, or retrieve the existing logger.
  #
  # Uses Log4r.
  def self.logger
    require 'log4r'
    include Log4r

    log = Logger['torkify']
    unless log
      log = Logger.new 'torkify'
      log.outputters = Outputter.stdout
      log.level = INFO
    end
    log
  end

  # Load all required files.
  def self.load_files
    require 'torkify/listener'
    require 'torkify/reader'
    require 'torkify/exceptions'
    require 'torkify/event_parser'
    require 'torkify/conductor'
    require 'torkify/observer_set'
    require 'torkify/events/event'
    require 'torkify/events/test_event'
    require 'torkify/events/pass_or_fail_event'
    require 'torkify/events/status_change_event'
  end
end
