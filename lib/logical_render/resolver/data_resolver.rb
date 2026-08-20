module LogicalRender
  class DataResolver
    def initialize(requirements, client:)
      @requirements = requirements
      @client = client
    end

    def resolve
    
      data = {}
      @requirements.each do |resource, requirement|
        data[resource] = resolve_resource(resource, requirement)
      end
      data

    end

    private

    def resolve_resource(resource, requirement)
      case resource
      when "assets"
        LogicalRender::API::Assets.new(@client).all
      when "domains"
        LogicalRender::API::Domains.new(@client).all
      when "nodes"
        fake_data["nodes"]
      when "primary_genders"
        domain_id = requirement[:args].first

        LogicalRender::API::PrimaryGenders
        .new(@client)
        .all(domain_id)
      when "sub_genders"
        domain_id = requirement[:args].first

        LogicalRender::API::SubGenders
          .new(@client)
          .all(domain_id)
      when "data"
        fake_data["data"]
      when "data_fields"
        fake_data["data_fields"]
      else
        raise "No resolver for resource: #{resource}"
      end
    end

    def fake_data
      @fake_data ||= LogicalRender::FakeData.new.resolve
    end
  end
end