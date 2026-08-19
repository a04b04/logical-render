require "dry/cli"
require_relative "logical_render/commands/render"
require_relative "logical_render/reserved/resources"
require_relative "logical_render/parser/template_parser"
require_relative "logical_render/resolver/data_resolver"
require_relative "logical_render/renderer/renderer"
require_relative "logical_render/reserved/fields"

require_relative "logical_render/api/client"
require_relative "logical_render/api/domains"
require_relative "logical_render/api/nodes"
require_relative "logical_render/api/primary_genders"
require_relative "logical_render/api/sub_genders"
require_relative "logical_render/api/assets"
require_relative "logical_render/api/data_fields"

module LogicalRender
  module CLI
    extend Dry::CLI::Registry

    register "render", Commands::Render

    # client = LogicalRender::API::Client.new(
    #   base_url: "http://10.151.0.57:3000/api/v1/"
    # )
    # assets_api = LogicalRender::API::Assets.new(client)
    # pp assets_api.all

    def self.start
      Dry::CLI.new(self).call
    end
  end
end