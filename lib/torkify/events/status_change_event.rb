require_relative 'event_message'

module Torkify

  # Event used for changes in test status.
  #
  # Types:
  #
  #  - pass_now_fail
  #  - fail_now_pass
  #
  # Includes the actual fail/pass event as a separate object.
  class StatusChangeEvent < Struct.new(:type, :file, :event)
    include EventMessage

    def to_s
      "#{type.upcase.gsub('_',' ')} #{file}"
    end
  end
end
