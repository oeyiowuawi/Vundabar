APP_ROOT = __dir__
require "./config/application.rb"
use Rack::MethodOverride
TodoApplication = Todolist::Application.new
require "./config/routes.rb"

run TodoApplication
