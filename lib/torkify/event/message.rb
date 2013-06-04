module Torkify::Event
  module Message
    def message
      "on_#{type}".to_sym
    end
  end
end
