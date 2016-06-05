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

    def render(*args)
      response(render_template(*args))
    end

    def response(body, status= 200, header={})
      @response = Rack::Response.new(body, status, header)
    end

    def get_response
      @response
    end

    def render_template view_name, locals = {}
      layout_template, view_template = prepare_view_template(view_name)
      title = view_name.to_s.tr("_", " ").capitalize
      view_object = get_view_object
      layout_template.render(view_object, title: title) do
        view_template.render(view_object, locals)
      end
    end

    def prepare_view_template(view_name)
      layout_file = File.join(APP_ROOT, "app", "views", "layouts", "application.html.erb")
      layout_template = Tilt::ERBTemplate.new(layout_file)
      view = "#{view_name}.html.erb"
      view_template = Tilt::ERBTemplate.new(File.join(APP_ROOT, "app", "views",
                                                      controller_name, view))
      [layout_template, view_template]
    end

    def get_view_object
      Struct.new("ViewObject")
      obj = Struct::ViewObject.new
      get_view_params.each do |key, value|
        obj.instance_variable_set(key, value)
      end
      obj
    end

    def get_view_params
      hash = {}
      variables = instance_variables - [:@request]
      variables.each { |variable| hash[variable] = instance_variable_get(variable) }
      hash
    end

    def controller_name
      klass = self.class.to_s.gsub(/Controller$/, "")
      klass.to_snake_case
    end

  end
end
