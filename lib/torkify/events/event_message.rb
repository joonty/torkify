module Torkify
  module EventMessage
    def message
      "on_#{type}".to_sym
    end
  end
end
