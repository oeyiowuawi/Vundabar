require "database_connector"
module Vundabar
  module ActiveRecord
    class BaseModel
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

      def self.create_table
        query = "CREATE TABLE IF NOT EXISTS #{@@table} (#{build_table_fields(@@properties).join(", "))}"
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

      def parse_constraint(constraints, column)
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


    end
  end
end
