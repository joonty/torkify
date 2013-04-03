module Torkify
  class TestEvent < Struct.new(:type, :file, :lines, :log_file, :worker)
  end
end
