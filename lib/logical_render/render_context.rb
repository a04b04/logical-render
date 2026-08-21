require "ostruct"

module LogicalRender
  class RenderContext
    attr_reader :alces

    def initialize(node:)
      @alces = OpenStruct.new(
        node: OpenStruct.new(
          name: node.name,
          group: OpenStruct.new(
            name: node.gender
          )
        )
      )
    end
  end
end