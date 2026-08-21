require "dry/cli"

require_relative "logical_render/commands/render"
require_relative "logical_render/commands/erb_help"

require_relative "logical_render/reserved/resources"
require_relative "logical_render/reserved/fields"

require_relative "logical_render/parser/template_parser"

require_relative "logical_render/resolver/data_resolver"
require_relative "logical_render/resolver/fake_data"

require_relative "logical_render/renderer/renderer"

require_relative "logical_render/api/client"
require_relative "logical_render/api/domains"
require_relative "logical_render/api/nodes"
require_relative "logical_render/api/primary_genders"
require_relative "logical_render/api/sub_genders"
require_relative "logical_render/api/assets"

require_relative "logical_render/render_context"
require_relative "logical_render/resolver/context_resolver"

module LogicalRender
  module CLI
    extend Dry::CLI::Registry

    register "render", Commands::Render
    register "erb-help", Commands::ErbHelp

    def self.start
      Dry::CLI.new(self).call
    end
  end
end