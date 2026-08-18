require "dry/cli"
require_relative "logical_render/commands/render"
require_relative "logical_render/reserved/resources"
require_relative "logical_render/parser/template_parser"
require_relative "logical_render/data_resolver"
require_relative "logical_render/renderer"

module LogicalRender
  module CLI
    extend Dry::CLI::Registry

    register "render", Commands::Render

    def self.start
      Dry::CLI.new(self).call
    end
  end
end