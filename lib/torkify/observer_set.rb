module Torkify
  require 'set'

  class ObserverSet
    def initialize
      @set = Set.new
    end

    def method_missing(name, *args)
      @set.send name, *args
    end

    def respond_to?(name)
      @set.respond_to? name
    end
  end
end
