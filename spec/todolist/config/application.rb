
require "vundabar"
$LOAD_PATH << File.join(File.dirname(__FILE__), "..","app", "controllers")

module Todolist
  class Application < Vundabar::Application
  end
end
