module LogicalRender
  module Parser
    class TemplateParser
      def initialize(template)
        @template = template
      end

      def resource
        match = @template.match(/(\w+)\.each/)
        return unless match
        match[1]
      end

      def fields
        matches = @template.scan(/(\w+)\.(\w+)/)

        matches.reject do |object, field|
          field == "each"
        end
      end

      def loop_variables
        matches = @template.scan(/(\w+)\.each do \|(\w+)\|/)

        matches.to_h do |resource, variable|
          [variable, resource]
        end
      end

      def requirements
        result = {}
        
        fields.each do |object, field|
          resource = loop_variables[object]
          next unless resource

          result[resource] ||= []
          result[resource] << field
        end
        result
      end

    end
  end
end