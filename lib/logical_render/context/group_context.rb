module LogicalRender
  module Context
    class GroupContext
      attr_reader :name, :index, :nodes

      def initialize(name:, index:, nodes:)
        @name = name
        @index = index
        @nodes = nodes
      end
    end
  end
end