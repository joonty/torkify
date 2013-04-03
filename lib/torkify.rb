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
    require 'torkify/reader'
    require 'torkify/exceptions'
    require 'torkify/event_parser'
    require 'torkify/conductor'
    require 'torkify/test_event'
    require 'torkify/pass_or_fail_event'
    require 'torkify/status_change_event'
    require 'torkify/observer_set'

    observers = ObserverSet.new
    observers << Observer.new
    reader = Reader.new
    conductor = Conductor.new reader, observers
    conductor.start
  end
end
