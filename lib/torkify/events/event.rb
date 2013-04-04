module Torkify
  class Event < Struct.new(:type)
    def to_s
      type
    end
  end
end
