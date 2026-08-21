module LogicalRender
  class ContextResolver
    def initialize(client)
      @client = client
    end

    def resolve(domain_name:, node_name: nil)
      domains_api = LogicalRender::API::Domains.new(@client)

      domain = domains_api.all.find do |item|
        item.name == domain_name
      end

      raise "Unknown domain: #{domain_name}" unless domain

      genders_api = LogicalRender::API::PrimaryGenders.new(@client)
      genders = genders_api.all(domain.id)

      groups = {}

      genders.each do |gender|
        nodes_api = LogicalRender::API::Nodes.new(@client)
        nodes = nodes_api.all(gender.id)

        groups[gender.name.downcase] =
          LogicalRender::Context::GroupContext.new(
            name: gender.name,
            index: gender.gender_index,
            nodes: nodes
          )
      end

      groups_context =
        LogicalRender::Context::GroupsContext.new(groups)

      unless node_name
        return {
          domain: domain,
          groups: groups_context
        }
      end

      genders.each do |gender|
        nodes_api = LogicalRender::API::Nodes.new(@client)
        nodes = nodes_api.all(gender.id)

        node = nodes.find do |item|
          item.name == node_name
        end

        next unless node

        full_node = nodes_api.find_by_name(
          gender.id,
          node_name
        )

        return {
          domain: domain,
          groups: groups_context,
          primary_gender: gender,
          node: full_node
        }
      end

      raise "Unknown node '#{node_name}' in domain '#{domain_name}'"
    end
  end
end