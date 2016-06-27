module Vundabar
  class BaseModel
    include Vundabar::ModelHelper
    def initialize(attributes = {})
      attributes.each { |column, value| send("#{column}=", value) }
    end

    def self.to_table(name)
      @table = name.to_s
    end

    def self.table_name
      @table
    end

    def self.property(column_name, column_properties)
      @properties ||= {}
      @properties[column_name] = column_properties
    end

    def self.properties
      @properties
    end

    def self.create_table
      query = "CREATE TABLE IF NOT EXISTS #{table_name} "\
      "(#{build_table_fields(@properties).join(', ')})"
      Database.execute_query(query)
      make_methods
    end

    def self.make_methods
      properties.keys.each do |column_name|
        define_method(column_name) do
          instance_variable_get("@" + column_name.to_s)
        end

        define_method("#{column_name}=") do |value|
          instance_variable_set("@" + column_name.to_s, value)
        end
      end
    end

    def self.build_table_fields(properties)
      all_properties = []
      properties.each do |field_name, constraints|
        column = []
        column << field_name.to_s
        parse_constraint(constraints, column)
        all_properties << column.join(" ")
      end
      all_properties
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
      "NOT NULL" unless value
    end

    def self.get_model_object(row)
      return nil unless row
      model_name = new
      properties.keys.each_with_index do |key, index|
        model_name.send("#{key}=", row[index])
      end
      model_name
    end

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
  end
end
