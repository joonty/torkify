module Torkify

  class StatusChangeEvent < Struct.new(:type, :file, :event)
    def to_s
      "#{type.upcase.gsub('_',' ')} #{file}"
    end
  end
end
