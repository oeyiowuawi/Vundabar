require "vundabar/version"
require 'active_support/inflector'
require "vundabar/utilities"
require "vundabar/dependencies"
require "vundabar/routing/routing"
require "vundabar/routing/mapper"
require "vundabar/routing/route"
require "vundabar/controller"
require "pry"
require "sqlite3"
require "vundabar/orm/database"
require "vundabar/orm/model_helper"
require "vundabar/orm/associations"
require "vundabar/orm/base_model"
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
        invalid_route_processor(request)
      end
    end

    def mapper
      @mapper ||= Routing::Mapper.new(routes.endpoints)
    end

    def call_controller_and_action(request, klass_and_method)
      Routing::Route.new(request, klass_and_method).dispatcher
    end

    def invalid_route_processor(request)
      response = BaseController.new(request).invalid_route(routes.endpoints)
      [404, {}, [response]]
    end
  end
end
