require "ostruct"

module LogicalRender
  module API
    class Domains
      def initialize(client)
        @client = client
      end

      def all
        response = @client.get("logical/domains")

        response.map do |domain|
          OpenStruct.new(
            id: domain["id"],
            data_id: domain["dataId"],
            name: domain["name"]
          )
        end
      end



    end
  end
end