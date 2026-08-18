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
        
        puts "Fields: #{parser.fields.inspect}"
        puts "Loops: #{parser.loop_variables.inspect}"
        puts "Requirements: #{parser.requirements.inspect}"

        requirements = parser.requirements
        resolver = LogicalRender::DataResolver.new(requirements)
        data = resolver.resolve
        renderer = LogicalRender::Renderer.new(template_contents, data)

        puts renderer.render


      end

    end
  end
end