module LogicalRender
  module Fields
    RESERVED = {
      "nodes" => %w[
        id
        node_index
        name
        gender_id
        gender
        sub_genders
        data_fields
      ],

      "primary_genders" => %w[
        id
        domain_id
        name
        data_id
        gender_index
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