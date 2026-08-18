require "erb"

module LogicalRender
  class Renderer 
    def initialize(template, data)
      @template = template
      @data = data
    end

    def render
      nodes = @data["nodes"]

      ERB.new(@template).result(binding)
    end




  end
end