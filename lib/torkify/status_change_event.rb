module Torkify

  class StatusChangeEvent < Struct.new(:type, :file, :event)
  end
end
