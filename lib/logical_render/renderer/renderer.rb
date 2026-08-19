require "erb"

module LogicalRender
  class Renderer
    def initialize(template, data)
      @template = template
      @data = data
    end

    def render
      nodes = @data["nodes"]
      primary_genders = @data["primary_genders"]
      sub_genders = @data["sub_genders"]
      domains = @data["domains"]
      data = @data["data"]
      data_fields = @data["data_fields"]
      gender_hierarchy = @data["gender_hierarchy"]
      assets = @data["assets"]

      ERB.new(@template).result(binding)
    end

  end
end