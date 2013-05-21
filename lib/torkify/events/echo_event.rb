require_relative 'event_message'

module Torkify

  # Event used for all events that have no associated data.
  #
  # Types:
  #
  #  - absorb
  #  - shutdown
  #  - startup
  #  - anything else...
  class EchoEvent < Struct.new(:type, :arguments)
    include EventMessage

    def to_s
      type
    end

    alias :args :arguments
  end
end

