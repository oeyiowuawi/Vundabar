
require "vundabar"
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "controllers")
$LOAD_PATH << File.join(File.dirname(__FILE__), "..", "app", "models")

module Todolist
  class Application < Vundabar::Application
  end
end
