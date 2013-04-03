require "torkify/version"

module Torkify
    class Observer
      def on_pass(event)
        puts event.inspect
      end

      def on_fail(event)
        puts event.inspect
      end
    end

  def self.start
    self.load_files
    observers = ObserverSet.new
    observers << Observer.new
    reader = Reader.new
    conductor = Conductor.new reader, observers
    conductor.start
  end

  def self.load_files
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
