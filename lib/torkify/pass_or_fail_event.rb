module Torkify
  class PassOrFailEvent < Struct.new(:type, :file, :lines, :log_file, :worker, :exit_code, :exit_info)
    def pid
      matched = exit_info.scan(/pid ([0-9]+)/).first
      matched.first.to_i if matched
    end
  end
end
