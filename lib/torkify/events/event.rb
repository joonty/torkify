require_relative 'event_message'

module Torkify

  # Event used for all events that have no associated data.
  #
  # Types:
  #
  #  - absorb
  #  - stop
  #  - anything else...
  class Event < Struct.new(:type)
    include EventMessage

    def to_s
      type
    end
  end
end
