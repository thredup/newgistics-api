module NewgisticsApi
  class Client
    def make_request(method, path)
      uri = URI.parse("#{host}#{path}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP.const_get(method.to_s.downcase.capitalize).new(uri.request_uri)
      request.add_field("X-API-Key", api_key)
      request["Accept"] = "application/json"

      if block_given?
        block_output = yield

        raise TypeError, "The output of the block must be a Hash" unless block_output.is_a?(Hash)

        request.body = block_output.to_json
        request["Content-Type"] = "application/json"
      end

      response = http.request(request)

      Response.new(self.class, response)
    end

    private

    def host
      NewgisticsApi.configuration.host
    end

    def api_key
      NewgisticsApi.configuration.api_key
    end

    class Response
      attr_reader :response, :parsed_body, :decorated_response

      def initialize(class_object, response)
        @class_object = class_object
        @response = response
        @parsed_body = JSON.parse(response.body)
        @decorated_response = class_object.const_defined?(:Decorator) ? class_object::Decorator.decorate(body) : nil
      end

      def body
        @parsed_body
      end

      def success?
        response.is_a?(Net::HTTPOK) || response.is_a?(Net::HTTPSuccess)
      end

    end
  end
end
