require "vundabar/version"

module Vundabar
  class Application
    def call(env)
      @req = Rack::Request.new(env)
      path = @req.path_info
      request_method = @req.request_method.downcase
      return [500, {}, []] if path == '/favicon.ico'
      controller, action = get_controller_and_action(path, request_method)
      response = controller.send(action)
      [200, {"Content-type" => "text/html"}, response]
    end

    def get_controller_and_action(path, verb)
      _, controller, action, others = path.split("/", 4)
      require "#{controller,downcase}_controller"
      controller = Object.const_get(controller.capitalize! + "Controller")
      action = action ? action : verb
      [controller, action]
  end
end
