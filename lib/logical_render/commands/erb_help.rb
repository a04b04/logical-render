module LogicalRender
  module Commands
    class ErbHelp < Dry::CLI::Command
      desc "Show supported ERB syntax and resources"

      def call(**)
        puts <<~HELP
          Logical Render ERB Help

          Supported resources:

            assets
            domains
            primary_genders

          Examples:

          Assets:

            <% assets.each do |asset| %>
              <%= asset.name %>
              <%= asset.u_size %>
            <% end %>

          Domains:

            <% domains.each do |domain| %>
              <%= domain.name %>
            <% end %>

          Primary genders for a domain:

            <% primary_genders(1).each do |gender| %>
              <%= gender.name %>
              <%= gender.gender_index %>
            <% end %>

          Conditions are supported:

            <% assets.each do |asset| %>
              <% if asset.u_size > 20 %>
                <%= asset.name %>
              <% end %>
            <% end %>

          Nested loops are supported.
        HELP
      end
    end
  end
end