module Vundabar
  module Routing
    class Router
      attr_accessor :endpoints
      def draw(&block)
        instance_eval(&block)
      end

      [:get, :post, :delete, :put, :patch].each do |method|
        define_method(method) do |path, options|
          path = "/#{path}" unless path[0] == "/"
          route_info = {
            path: path,
            klass_and_method: controller_and_action(options[:to]),
            pattern: pattern_for(path)
          }
          endpoints[method] << route_info
        end
      end

      def root(address)
        get "/", to: address
      end

      def resources(args)
        args = args.to_s
        get("/#{args}", to: "#{args}#index")
        get("/#{args}/new", to: "#{args}#new")
        get("/#{args}/:id", to: "#{args}#show")
        get("/#{args}/:id/edit", to: "#{args}#edit")
        delete("/#{args}/:id", to: "#{args}#destroy")
        post("/#{args}/create", to: "#{args}#create")
        put("/#{args}/:id", to: "#{args}#update")
      end

      def pattern_for(path)
        placeholders = []
        new_path = path.gsub(/(:\w+)/) do |match|
          placeholders << match[1..-1].freeze
          "(?<#{placeholders.last}>[^?/#]+)"
        end
        [/^#{new_path}$/, placeholders]
      end

      def endpoints
        @endpoints ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def controller_and_action(to)
        controller, action = to.split('#')
        controller = "#{controller.to_camel_case}Controller"
        [controller, action]
      end
    end
  end
end
