module LogicalRender
  module Resources
    RESERVED = %w[
    nodes
    primary_genders
    sub_genders
    domains
    data
    data_fields].freeze

    def self.valid?(name)
      RESERVED.include?(name)
    end
  end
end