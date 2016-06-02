module Vundabar
  module Routing
    class Router
      attr_accessor :endpoints
      def draw(&block)
        instance_eval &block
      end


      [:get, :post, :delete, :put, :patch].each do |method|
        define_method(method) do |path, to:|
          path = "/#{path}" unless path[0] == "/"
          route_info = {
                          # path: path,
                          klass_and_method: controller_and_action(to),
                          pattern: pattern_for(path)
                       }
          endpoints[method] << route_info
        end
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
        @endpoints ||= Hash.new {|hash, key| hash[key] = []}
      end

      def controller_and_action(to)
        controller, action = to.split('#')
        controller = "#{controller.capitalize!}Controller"
        [controller, action]
      end
    end
  end
end
