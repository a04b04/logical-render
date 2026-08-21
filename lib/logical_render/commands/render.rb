module LogicalRender
  module Commands
    class Render < Dry::CLI::Command
      desc "Render a template"

      argument :template,
               required: true,
               desc: "Path to template file"

      option :domain,
             type: :string,
             desc: "Name of the cluster (domain name)"

      option :node,
             type: :string,
             desc: "Node name"

      def call(template:, domain: nil, node: nil, **)
        template_contents = File.read(template)

        parser = LogicalRender::Parser::TemplateParser.new(template_contents)

        requirements = parser.requirements
        puts "Requirements: #{requirements.inspect}"

        client = LogicalRender::API::Client.new(
          base_url: "http://10.151.0.57:3000/api/v1/"
        )

        context = nil

        if domain && node
          context_resolver = LogicalRender::ContextResolver.new(client)

          context = context_resolver.resolve(
            domain_name: domain,
            node_name: node
          )
        end

        resolver = LogicalRender::DataResolver.new(
          requirements,
          client: client
        )

        data = resolver.resolve

        if context
          data["domain"] = context[:domain]
          data["primary_gender"] = context[:primary_gender]
          data["current_node"] = context[:node]
        end

        renderer = LogicalRender::Renderer.new(
          template_contents,
          data
        )

        puts renderer.render

      rescue RuntimeError => e
        puts "Error: #{e.message}"
      end
    end
  end
end