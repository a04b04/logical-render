require "ostruct"

module LogicalRender
  module API
    class Assets
      def initialize(client)
        @client = client
      end

      def all
        response = @client.get("physical/assets")

        response.map do |asset|
          OpenStruct.new(
            id: asset["id"],
            name: asset["name"],
            notes: asset["notes"],
            u_size: asset["uSize"],
            u_top: asset["uTop"],
            u_bottom: asset["uBottom"]
          )
        end
      end
    end
  end
end