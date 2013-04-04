require "torkify/version"

module Torkify
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

  def self.listener(*args)
    load_files
    Listener.new(*args)
  end

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
