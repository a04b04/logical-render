require "net/http"
require "json"
require "uri"

module LogicalRender
  module API
    class Client
      def initialize(base_url:)
        @base_url = base_url
      end

      def get(path)
        uri = URI.join(@base_url, path)
        response = Net::HTTP.get_response(uri)
        unless response.is_a?(Net::HTTPSuccess)
          raise "API request failed: #{response.code} #{response.message}"
        end
        JSON.parse(response.body)
      end

      
    end
  end
end