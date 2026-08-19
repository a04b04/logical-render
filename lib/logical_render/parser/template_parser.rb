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
        result = {}

        walk(ast, {}, result)

        result.transform_values(&:uniq)
      end

      def inspect_ast
        walk(ast)
      end

      private

      def extract_each_loop(ast_node)
        resource = extract_root_resource(ast_node[1])
        variable = ast_node[2][1][1][1][0][1]

        {
          resource: resource,
          variable: variable
        }
      end

      def extract_root_resource(ast_node)
        return unless ast_node.is_a?(Array)

        if ast_node[0] == :vcall
          return ast_node.dig(1, 1)
        end

        if ast_node[0] == :call
          return extract_root_resource(ast_node[1])
        end

        if ast_node[0] == :method_add_block
          return extract_root_resource(ast_node[1])
        end

        nil
      end

      def extract_field_call(ast_node)
        return unless ast_node[0] == :call

        receiver = ast_node[1]
        method_name = ast_node[3]

        return unless receiver&.dig(0) == :var_ref
        return unless receiver&.dig(1, 0) == :@ident
        return unless method_name&.dig(0) == :@ident

        {
          variable: receiver.dig(1, 1),
          field: method_name[1]
        }
      end

      def walk(ast_node, scope = {}, requirements = {})
        return unless ast_node.is_a?(Array)

        if ast_node[0] == :method_add_block
          loop = extract_each_loop(ast_node)

          if loop
            resource = loop[:resource]
            variable = loop[:variable]

            unless LogicalRender::Resources.valid?(resource)
              raise "Unknown resource: #{resource}"
            end

            new_scope = scope.merge(variable => resource)
            block_body = ast_node[2][2]

            walk(block_body, new_scope, requirements)

            return
          end
        end

        if ast_node[0] == :call
          field = extract_field_call(ast_node)

          if field
            resource = scope[field[:variable]]

            if resource
              unless LogicalRender::Fields.valid?(resource, field[:field])
                raise "Unknown field '#{field[:field]}' for resource '#{resource}'"
              end

              requirements[resource] ||= []
              requirements[resource] << field[:field]
            end
          end
        end

        ast_node.each do |child|
          walk(child, scope, requirements)
        end
      end
    end
  end
end