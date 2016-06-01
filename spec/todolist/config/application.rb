
require "vundabar"
$LOAD_PATH << File.join(File.dirname(__FILE__), "..","app", "controllers")

module Todolist
  require "pry"; binding.pry
  class Application < Vundabar::Application
  end
end
