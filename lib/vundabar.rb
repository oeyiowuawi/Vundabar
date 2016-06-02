require "vundabar/version"
require "vundabar/utilities"
require "vundabar/dependencies"
require "vundabar/routing/routing"
require "vundabar/routing/mapper"
require "pry"
module Vundabar
  class Application
    attr_reader :routes
    def initialize
      @routes = Routing::Router.new
    end

    def call(env)
      request = Rack::Request.new(env)
      route = mapper.find_route(request)
      if route
        [200, {"Content-type" => "text/html"}, ["Yes, it is working"]]
      else
        [200, {"Content-type" => "text/html"}, ["Nah, it is not working"]]
      end
    end

    def mapper
      @mapper ||= Routing::Mapper.new(routes.endpoints)
    end

  end
end
