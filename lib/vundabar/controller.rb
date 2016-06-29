require "tilt/erb"
module Vundabar
  class BaseController
    attr_reader :request
    def initialize(request)
      @request = request
    end

    def params
      request.params
    end

    def redirect_to(address, status: 301)
      response([], status, "Location" => address)
    end

    def render(*args)
      response(render_template(*args))
    end

    def response(body, status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def get_response
      @response
    end

    def invalid_route(endpoints)
      template = File.join(APP_ROOT, "public", "invalid_route.html.erb")
      locals = { path: request.path_info, endpoints: endpoints }
      Tilt::ERBTemplate.new(template).render(self, locals)
    end

    def render_template(view_name, locals = {})
      layout_template, view_template = prepare_view_template(view_name)
      title = view_name.to_s.tr("_", " ").capitalize
      layout_template.render(self, title: title) do
        view_template.render(self, locals)
      end
    end

    def prepare_view_template(view_name)
      layout_file = File.join(
        APP_ROOT,
        "app",
        "views",
        "layouts",
        "application.html.erb"
      )
      layout_template = Tilt::ERBTemplate.new(layout_file)
      view = "#{view_name}.html.erb"
      view_file = File.join(
        APP_ROOT,
        "app",
        "views",
        controller_name,
        view
      )
      view_template = Tilt::ERBTemplate.new(view_file)
      [layout_template, view_template]
    end

    def controller_name
      klass = self.class.to_s.gsub(/Controller$/, "")
      klass.to_snake_case
    end
  end
end
