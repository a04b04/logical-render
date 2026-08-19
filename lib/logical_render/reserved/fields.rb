module LogicalRender
  module Fields
    RESERVED = {
      "nodes" => %w[
        id
        primary_gender_id
        name
        data_id
        index
        uuid
      ],

      "primary_genders" => %w[
        id
        domain_id
        name
        data_id
        index
      ],

      "sub_genders" => %w[
        id
        domain_id
        name
        data_id
      ],

      "domains" => %w[
        id
        name
        data_id
      ],

      "data" => %w[
        id
      ],

      "data_fields" => %w[
        id
        data_id
        name
        identifier
        type
        value
        deletable
      ],

      "assets" => %w[
        id
        name
        u_size
        u_top
        u_bottom
        notes]


    }.freeze

    def self.valid?(resource, field)
      RESERVED.fetch(resource, []).include?(field)
    end
  end
end