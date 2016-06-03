module Vundabar
  module Routing
    class Mapper
      attr_reader :endpoints, :request
      def initialize(endpoints)
        @endpoints = endpoints
      end

      def find_route(request)
        @request = request
        path = request.path_info
        method = request.request_method.downcase.to_sym
        endpoints[method].find do |endpoint|
          match_path_with_endpoint path, endpoint
        end
      end

      def match_path_with_endpoint path, endpoint
        regex, placeholders = endpoint[:pattern]
        if regex =~ path
          match_data = Regexp.last_match
          placeholders.each do |placeholder|
            request.update_param(placeholder, match_data[placeholder])
          end
          true
        end
      end

    end
  end
end
