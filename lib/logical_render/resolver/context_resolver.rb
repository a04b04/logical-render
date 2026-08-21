module LogicalRender
  class ContextResolver
    def initialize(client)
      @client = client
    end

    def resolve(domain_name:, node_name:)
      domains_api = LogicalRender::API::Domains.new(@client)

      domain = domains_api.all.find do |item|
        item.name == domain_name
      end

      raise "Unknown domain: #{domain_name}" unless domain

      genders_api = LogicalRender::API::PrimaryGenders.new(@client)

      genders = genders_api.all(domain.id)

      genders.each do |gender|
        nodes_api = LogicalRender::API::Nodes.new(@client)

        nodes = nodes_api.all(gender.id)

        node = nodes.find do |item|
          item.name == node_name
        end

        next unless node

        return {
          domain: domain,
          primary_gender: gender,
          node: node
        }
      end

      raise "Unknown node '#{node_name}' in domain '#{domain_name}'"
    end
  end
end