require "torkify/version"
require 'log4r'

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
  include Log4r

  # Create a listener object and load all required files.
  def self.listener(*args)
    require 'torkify/listener'
    Listener.new(*args)
  end

  # Create a logger object, or retrieve the existing logger.
  #
  # Uses Log4r.
  def self.logger
    log = Logger['torkify']
    unless log
      log = Logger.new 'torkify'
      log.outputters = Outputter.stdout
      log.level = INFO
    end
    log
  end
end
