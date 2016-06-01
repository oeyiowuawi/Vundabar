module Vundabar
  module Routing
    class Router
      def draw(&block)
        instance_eval &block
      end
    end
  end
end
