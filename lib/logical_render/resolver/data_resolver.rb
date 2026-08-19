module LogicalRender
  class DataResolver
    def initialize(requirements, client:)
      @requirements = requirements
      @client = client
    end

    def resolve
      data = {}
      @requirements.each_key do |resource|
        data[resource] = resolver_for(resource).all
      end
      data
    end

    private

    def resolver_for(resource)
      case resource
      when "assets"
        LogicalRender::API::Assets.new(@client)
      when "domains"
        LogicalRender::API::Domains.new(@client)
      when "nodes"
        LogicalRender::API::Nodes.new(@client)
      else
        raise "No resolver for resource: #{resource}"
      end
    end
  end
end