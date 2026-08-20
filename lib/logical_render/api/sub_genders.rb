require "ostruct"

module LogicalRender
  module API
    class SubGenders
      def initialize(client)
        @client = client
      end

      def all(domain_id)
        response = @client.get("logical/subgenders/all/#{domain_id}")


        response.map do |sub_gender|
          OpenStruct.new(
            id: sub_gender["id"],
            domain_id: sub_gender["domainId"],
            data_id: sub_gender["dataId"],
            name: sub_gender["name"]
          )
        end
      end

      def find(id)
        response = @client.get("logical/subgenders/#{id}")

        OpenStruct.new(
          id: response["id"],
          domain_id: response["domainId"],
          name: response["name"],
          data_id: response["dataId"],
          data_fields: response["dataFields"]
        )
      end
    end
  end
end