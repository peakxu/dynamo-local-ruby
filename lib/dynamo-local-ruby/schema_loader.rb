# encoding: utf-8
require 'aws-sdk'

# Start dynamo DB local
module DynamoLocalRuby
  # Helper for creating tables from a schema definition
  class SchemaLoader
    def initialize(dynamo_client)
      @dynamo = Aws::DynamoDB::Resource.new(client: dynamo_client)
    end

    # Expect schema to have form
    # {
    #   'table_name' => {
    #     keys: {
    #       'foo' => { attribute_type: 'S', key_type: 'HASH' }
    #     },
    #     capacity: { read: 1, write: 1 }  # optional
    #   }
    # }
    def load(schema)
      schema.each { |name, table_schema| load_table(name, table_schema) }
    end

    private

    def load_table(name, schema)
      @dynamo.table(name).table_status
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException
      opts = { table_name: name, attribute_definitions: [],
               key_schema: [], provisioned_throughput: {} }
      load_keys_to_opts(opts, schema)
      load_capacity_to_opts(opts, schema)
      @dynamo.create_table(opts)
    end

    def load_keys_to_opts(opts, schema)
      schema[:keys].each do |key, payload|
        opts[:attribute_definitions] << {
          attribute_name: key.to_s, attribute_type: payload[:attribute_type] }
        opts[:key_schema] << {
          attribute_name: key.to_s, key_type: payload[:key_type] }
      end
    end

    def load_capacity_to_opts(opts, schema)
      read = schema[:capacity] ? schema[:capacity][:read] : 1
      write = schema[:capacity] ? schema[:capacity][:write] : 1
      opts[:provisioned_throughput] = {
        read_capacity_units: read, write_capacity_units: write }
    end
  end
end
