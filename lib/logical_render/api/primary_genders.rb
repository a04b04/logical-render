require "ostruct"

module LogicalRender
  module API
    class PrimaryGenders
      def initialize(client)
        @client = client
      end

      def all (domain_id)
        response = @client.get("logical/genders/all/#{domain_id}")

        response.map do |gender|
          OpenStruct.new(
            id: gender["id"],
            domain_id: gender["domainId"],
            name: gender["name"],
            gender_index: gender["genderIndex"]
          )
        end
      end

      def fine(id)
        response = @client.get("logical/genders/#{id}")

        OpenStruct.new(
          id: response["id"],
          domain_id: response["domainId"],
          name: response["name"],
          data_id: response["dataId"],
          sub_genders: response["subGenders"],
          data_fields: response["dataFields"]
        )
      end



    end
  end
end