require "vundabar/version"
require "vundabar/utilities"
require "vundabar/dependencies"
require "vundabar/routing/routing"
require "vundabar/routing/mapper"
require "vundabar/routing/route"
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
        call_controller_and_action(request, route[:klass_and_method])
      else
        [404, {}, ["OOOPPSSSS!!!, the path you seek is not available, Old sport "]]
      end
    end

    def mapper
      @mapper ||= Routing::Mapper.new(routes.endpoints)
    end

    def call_controller_and_action(request, klass_and_method)
      Routing::Route.new(request, route[:klass_and_method]).dispatcher
    end
  end
end
