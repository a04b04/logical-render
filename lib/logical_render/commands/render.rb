module LogicalRender
  module Commands
    class Render < Dry::CLI::Command
      desc "Render a template"

      argument :template,
               required: true,
               desc: "Path to template file"

      def call(template:, **)
        template_contents = File.read(template)

        parser = LogicalRender::Parser::TemplateParser.new(template_contents)
        # pp parser.ast

        

        requirements = parser.requirements
        puts "Requirements: #{requirements.inspect}"

        client = LogicalRender::API::Client.new(
          base_url: "http://10.151.0.57:3000/api/v1/"
        )

        # nodes_api = LogicalRender::API::Nodes.new(client)
        # pp nodes_api.all(1)

        resolver = LogicalRender::DataResolver.new(
          requirements,
          client: client
        )

        data = resolver.resolve

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