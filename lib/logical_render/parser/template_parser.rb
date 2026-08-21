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

        result.each_value do |requirement|
          requirement[:fields].uniq!
        end

        result
      end

      def inspect_ast
        walk(ast)
      end

      private

      def extract_each_loop(ast_node)
        resource = extract_root_resource(ast_node[1])
        args = extract_arguments(ast_node[1])
        variable = ast_node[2][1][1][1][0][1]

        {
          resource: resource,
          args: args,
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

        if ast_node[0] == :fcall
          return ast_node.dig(1, 1)
        end

        if ast_node[0] == :method_add_arg
          return extract_root_resource(ast_node[1])
        end

        nil
      end

      def extract_arguments(ast_node)
        return [] unless ast_node.is_a?(Array)

        if ast_node[0] == :method_add_arg
          args_node = ast_node.dig(2, 1)

          return [] unless args_node&.dig(0) == :args_add_block

          args = args_node[1]

          return args.map do |arg|
            case arg[0]
            when :@int
              arg[1].to_i
            when :@tstring_content
              arg[1]
            else
              nil
            end
          end.compact
        end

        if ast_node[0] == :call
          return extract_arguments(ast_node[1])
        end

        []
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

           context_resources = %w[
              node
              groups
              domain
              primary_gender
            ]

            if context_resources.include?(resource)
              block_body = ast_node[2][2]
              walk(block_body, scope, requirements)
              return
            end

            unless LogicalRender::Resources.valid?(resource)
              raise "Unknown resource: #{resource}"
            end

            new_scope = scope.merge(
              variable => {
                resource: resource,
                args: loop[:args]
              }
            )

            block_body = ast_node[2][2]

            walk(block_body, new_scope, requirements)

            return
          end
        end

        if ast_node[0] == :call
          field = extract_field_call(ast_node)

          if field
            scope_entry = scope[field[:variable]]

            if scope_entry
              resource = scope_entry[:resource]
              args = scope_entry[:args]

              unless LogicalRender::Fields.valid?(resource, field[:field])
                raise "Unknown field '#{field[:field]}' for resource '#{resource}'"
              end

              requirements[resource] ||= {
                args: args,
                fields: []
              }

              requirements[resource][:fields] << field[:field]
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