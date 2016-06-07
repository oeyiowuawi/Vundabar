require "database_connector"
require "querry"
  module Vundabar
    class BaseModel < Queries
      @@table = ""
      @@properties = {}
      @@db ||= Database.connect

      def self.to_table(name)
        @@table = name.to_s
      end

      def self.property column_name, column_properties
        @@properties[column_name] = column_properties
        attr_accessor column_name
      end

      def table_columns
        columns = @@properties.keys
        columns.delete(:id)
        columns.map(&:to_s).join(", ")
      end

      def self.create_table
        query = "CREATE TABLE IF NOT EXISTS #{@@table} (#{build_table_fields(@@properties).join(", "))}"
        @@db.execute(query)
      end

      def self.build_table_fields(properties)
        all_properties = []
        column = []
        properties.each do |field_name, constraints|
          column << field_name.to_s
          parse_constraint(constraints, column)
          all_properties << column.join(" ")
        end
      end

      def self.parse_constraint(constraints, column)
        constraints.each do |attribute, value|
          column << send(attribute.to_s, value)
        end
      end

      def self.type(value)
        value.to_s
      end

      def self.primary_key(value)
        "PRIMARY KEY AUTOINCREMENT" if value
      end

      def self.nullable(value)
        "NOT NULL" if value
      end

      def record_placeholders
        (["?"] * (@@properties.keys.size) - 1).join(", ")
      end

      def record_values
        column_names = @@properties.keys
        column_names.delete(:id)
        column_names.map {|column_name| send(column_name)}
      end

    end
  end
