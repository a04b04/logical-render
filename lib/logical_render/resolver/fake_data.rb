require "ostruct"

module LogicalRender
  class FakeData

    def resolve
      {
        "nodes" => [
          OpenStruct.new(
            id: 1,
            primary_gender_id: 1,
            name: "node01",
            data_id: 1,
            index: 0,
            uuid: "abc-123"
          ),
          OpenStruct.new(
            id: 2,
            primary_gender_id: 1,
            name: "node02",
            data_id: 2,
            index: 1,
            uuid: "def-456"
          ),
          OpenStruct.new(
            id: 3,
            primary_gender_id: 2,
            name: "storage01",
            data_id: 3,
            index: 2,
            uuid: "ghi-789"
          )
        ],

        "primary_genders" => [
          OpenStruct.new(
            id: 1,
            domain_id: 1,
            name: "compute",
            data_id: 4,
            index: 0
          ),
          OpenStruct.new(
            id: 2,
            domain_id: 2,
            name: "storage",
            data_id: 5,
            index: 1
          )
        ],

        "sub_genders" => [
          OpenStruct.new(
            id: 1,
            domain_id: 1,
            name: "gpu",
            data_id: 6
          ),
          OpenStruct.new(
            id: 2,
            domain_id: 1,
            name: "cpu",
            data_id: 7
          ),
          OpenStruct.new(
            id: 3,
            domain_id: 2,
            name: "nfs",
            data_id: 8
          )
        ],

        "domains" => [
          OpenStruct.new(
            id: 1,
            name: "compute",
            data_id: 9
          ),
          OpenStruct.new(
            id: 2,
            name: "storage",
            data_id: 10
          )
        ],

        "data" => [
          OpenStruct.new(id: 1),
          OpenStruct.new(id: 2),
          OpenStruct.new(id: 3),
          OpenStruct.new(id: 4),
          OpenStruct.new(id: 5)
        ],

        "data_fields" => [
          OpenStruct.new(
            id: 1,
            data_id: 1,
            name: "ip_address",
            identifier: "ip",
            type: "string",
            value: "10.10.0.1",
            deletable: false
          ),
          OpenStruct.new(
            id: 2,
            data_id: 2,
            name: "ip_address",
            identifier: "ip",
            type: "string",
            value: "10.10.0.2",
            deletable: false
          ),
          OpenStruct.new(
            id: 3,
            data_id: 3,
            name: "mount_path",
            identifier: "mount",
            type: "string",
            value: "/shared",
            deletable: true
          ),
          OpenStruct.new(
            id: 4,
            data_id: 1,
            name: "memory_gb",
            identifier: "memory",
            type: "integer",
            value: "256",
            deletable: false
          )
        ]
      }
    end
  end
end