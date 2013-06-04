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
  class EchoEvent < Struct.new(:type, :arguments)
    include Message

    def to_s
      type
    end

    alias :args :arguments
  end
end

