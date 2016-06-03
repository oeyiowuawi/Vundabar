module Vundabar
  class BaseController
    attr_reader :request
    def initialize(request)
      @request = request
    end

    def params
      request.params
    end

    def controller_name
      klass = self.gsub(/Controller$/, "")
      klass.to_underscore
    end

  end
end
