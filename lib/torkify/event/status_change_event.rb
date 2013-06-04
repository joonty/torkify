require_relative 'message'

module Torkify::Event

  # Event used for changes in test status.
  #
  # Types:
  #
  #  - pass_now_fail
  #  - fail_now_pass
  #
  # Includes the actual fail/pass event as a separate object.
  class StatusChangeEvent < Struct.new(:type, :file, :event)
    include Message

    def to_s
      "#{type.upcase.gsub('_',' ')} #{file}"
    end
  end
end
