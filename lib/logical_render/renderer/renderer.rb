require "erb"

module LogicalRender
  class Renderer
    def initialize(template, data)
      @template = template
      @data = data
    end

    def render
      node = @data["current_node"]
      primary_genders = @data["primary_genders"]
      sub_genders = @data["sub_genders"]
      domain = @data["domain"]
      gender_hierarchy = @data["gender_hierarchy"]
      assets = @data["assets"]
      groups = @data["groups"]

      ERB.new(@template).result(binding)
    end

    def primary_genders(domain_id)
      @data["primary_genders"]
    end

    def nodes(gender_id)
      @data["nodes"]
    end

    def sub_genders(domain_id)
      @data["sub_genders"]
    end

  end
end