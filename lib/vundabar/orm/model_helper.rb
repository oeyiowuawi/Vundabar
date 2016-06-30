module Vundabar
  module ModelHelper
    def self.included(base)
      base.extend ClassMethods
    end

    private

    def table_columns
      columns = self.class.properties.keys
      columns.delete(:id)
      columns.map(&:to_s).join(", ")
    end

    def update_placeholders(attributes = self.class.properties)
      columns = attributes.keys
      columns.delete(:id)
      columns.map { |column| "#{column}= ?" }.join(", ")
    end

    def update_values(attributes)
      attributes.values << id
    end

    def record_placeholders
      (["?"] * (self.class.properties.keys.size - 1)).join(",")
    end

    def record_values
      column_names = self.class.properties.keys
      column_names.delete(:id)
      column_names.map { |column_name| send(column_name) }
    end

    module ClassMethods
      def table_name
        @table
      end

      def make_methods
        properties.keys.each do |column_name|
          attr_accessor column_name
        end
      end

      def build_table_fields(properties)
        all_properties = []
        properties.each do |field_name, constraints|
          column = []
          column << field_name.to_s
          parse_constraint(constraints, column)
          all_properties << column.join(" ")
        end
        all_properties
      end

      def parse_constraint(constraints, column)
        constraints.each do |attribute, value|
          column << send(attribute.to_s, value)
        end
      end

      def type(value)
        value.to_s
      end

      def primary_key(value)
        "PRIMARY KEY AUTOINCREMENT" if value
      end

      def nullable(value)
        "NOT NULL" unless value
      end

      def get_model_object(row)
        return nil unless row
        model_name = new
        properties.keys.each_with_index do |key, index|
          model_name.send("#{key}=", row[index])
        end
        model_name
      end
    end
  end
end
