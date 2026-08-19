require_relative "../parser/template_parser"

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
        requirements = parser.requirements
        puts "Requirements: #{requirements.inspect}"
        resolver = LogicalRender::DataResolver.new(requirements)
        data = resolver.resolve
        renderer = LogicalRender::Renderer.new(template_contents, data)
        puts renderer.render

      rescue RuntimeError => e 
        puts "Error: #{e.message}"
      end




    end
  end
end