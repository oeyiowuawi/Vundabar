APP_ROOT = __dir__
require_relative "config/application.rb"
use Rack::MethodOverride
VundabarApp = Vundabar::Application.new
require_relative "config/routes.rb"
run VundabarApp
