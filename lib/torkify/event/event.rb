require_relative 'message'

module Torkify::Event

  # Event used for all events that have no associated data.
  #
  # Types:
  #
  #  - absorb
  #  - shutdown
  #  - startup
  #  - anything else...
  class Event < Struct.new(:type)
    include Message

    def to_s
      type
    end
  end
end
