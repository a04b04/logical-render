require "ostruct"

module LogicalRender
  module API
    class Nodes
      def initialize(client)
        @client = client
      end

      def all(gender_id)
        response = @client.get("logical/genders/#{gender_id}/node/all")

        response.map do |node|
          OpenStruct.new(
            id: node["id"],
            node_index: node["nodeIndex"],
            name: node["name"],
            gender_id: node["genderId"],
            gender: node["gender"],
            sub_genders: node["subGenders"],
            data_fields: node["dataFields"],
            config: LogicalRender::Context::ConfigContext.new(
              node["dataFields"]
            )
          )
        end
      end

      def find_by_name(gender_id, name)
        response = @client.get(
          "logical/genders/#{gender_id}/node/#{URI.encode_www_form_component(name)}"
        )

        OpenStruct.new(
          id: response["id"],
          node_index: response["nodeIndex"],
          name: response["name"],
          gender_id: response["genderId"],
          gender: response["gender"],
          sub_genders: response["subGenders"],
          data_fields: response["dataFields"],
          config: LogicalRender::Context::ConfigContext.new(
            response["dataFields"]
          )
        )
      end

      def find(id)
        response = @client.get("logical/nodes/#{id}")

        OpenStruct.new(
          id: response["id"],
          primary_gender_id: response["primaryGenderId"],
          data_id: response["dataId"],
          name: response["name"],
          data_fields: response["dataFields"],
          config: LogicalRender::Context::ConfigContext.new(
            response["dataFields"]
          )
        )
      end
    end
  end
end