module LogicalRender
  module Context
    class GroupsContext
      def initialize(groups)
        @groups = groups
      end

      def method_missing(method_name, *args)
        return super unless args.empty?

        group = @groups[method_name.to_s]

        return group if group

        super
      end

      def respond_to_missing?(method_name, include_private = false)
        @groups.key?(method_name.to_s) || super
      end
    end
  end
end