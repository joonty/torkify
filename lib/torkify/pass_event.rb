module Torkify
  PassEvent = Struct.new(:file, :lines, :log_file, :worker, :exit_code, :exit_info) do
  end
end
