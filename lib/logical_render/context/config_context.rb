module LogicalRender
  module Context
    class ConfigContext
      def initialize(data_fields)
        @data_fields = data_fields || {}
      end

      def method_missing(method_name, *args)
        return super unless args.empty?

        identifier = method_name.to_s

        # Ruby-friendly names can map to API identifiers like:
        # ip_address -> ip-address
        field =
          @data_fields[identifier] ||
          @data_fields[identifier.tr("_", "-")]

        return super unless field

        field["value"]
      end

      def respond_to_missing?(method_name, include_private = false)
        identifier = method_name.to_s

        @data_fields.key?(identifier) ||
          @data_fields.key?(identifier.tr("_", "-")) ||
          super
      end
    end
  end
end