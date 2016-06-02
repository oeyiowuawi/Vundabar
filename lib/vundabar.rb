require "vundabar/version"
require "vundabar/utilities"
require "vundabar/dependencies"
require "vundabar/routing/routing"
require "pry"
module Vundabar
  class Application
    attr_reader :routes
    def initialize
      @routes = Routing::Router.new
    end

    def call(env)
      @req = Rack::Request.new(env)
      path = @req.path_info
      request_method = @req.request_method.downcase
      return [500, {}, []] if path == '/favicon.ico'
      controller, action = get_controller_and_action(path, request_method)
      response = controller.new.send(action)
      [200, {"Content-type" => "text/html"}, response]
    end

    def get_controller_and_action(path, verb)
      _, controller, action, others = path.split("/", 4)
      require "#{controller.downcase}_controller"
      controller = Object.const_get(controller.capitalize! + "Controller")
      action = action.nil? ? verb : "#{verb}_#{action}"
      [controller, action]
    end

  end
end
