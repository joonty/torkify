module Torkify
  class Reader
    def initialize(command = 'tork-remote tork-engine')
      IO.popen(command, 'r+')
    end
  end
end
