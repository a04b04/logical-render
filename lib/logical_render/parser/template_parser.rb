require "ripper"
require "pp"

module LogicalRender
  module Parser
    class TemplateParser
      def initialize(template)
        @template = template
      end

      def ruby_code
        @template.scan(/<%=?\s*(.*?)\s*%>/m).flatten.join("\n")
      end

      def ast
        Ripper.sexp(ruby_code)
      end

      def requirements
        loops = {}
        fields = []

        walk(ast) do |node|
          if node[0] == :method_add_block
            loop = extract_each_loop(node)

            if loop
              unless LogicalRender::Resources.valid?(loop[:resource])
                raise "Unknown resource: #{loop[:resource]}"
              end
              loops[loop[:variable]] = loop[:resource]
            end
          end

          if node[0] == :call
            field = extract_field_call(node)
            fields << field if field
          end
        end

        result = {}

        fields.each do |field|
          resource = loops[field[:variable]]
          next unless resource

          unless LogicalRender::Fields.valid?(resource, field[:field])
            raise "Unknown field '#{field[:field]}' for resource '#{resource}'"
          end

          result[resource] ||= []
          result[resource] << field[:field]
        end

        result.transform_values(&:uniq)
      end

      private

      def extract_each_loop(node)
        resource = node[1][1][1][1]
        variable = node[2][1][1][1][0][1]

        {
          resource: resource,
          variable: variable
        }
      end

      def extract_field_call(node)
        return unless node[0] == :call

        receiver = node[1]
        method_name = node[3]

        return unless receiver&.dig(0) == :var_ref
        return unless receiver&.dig(1, 0) == :@ident
        return unless method_name&.dig(0) == :@ident

        {
          variable: receiver.dig(1, 1),
          field: method_name[1]
        }
      end

      def walk(node, &block)
        return unless node.is_a?(Array)

        yield node

        node.each do |child|
          walk(child, &block)
        end
      end
    end
  end
end