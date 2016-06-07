module Vundabar
  module Routing
    class Route
      attr_reader :controller_name, :action, :request
      def initialize(request, klass_and_method)
        @request = request
        @controller_name, @action = klass_and_method
      end

      def dispatcher
        controller = controller_name.to_constant.new(request)
        controller.send(action)
        controller.render(action) unless controller.get_response
        controller.get_response
      end
    end
  end
end
