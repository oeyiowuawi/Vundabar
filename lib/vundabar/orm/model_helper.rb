module Vundabar
  class ModelHelper
    @@table = ""
    @@properties = {}
    @@db ||= Vundabar::Database.connect

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
      query = "CREATE TABLE IF NOT EXISTS #{@@table} (#{build_table_fields(@@properties).join(", ")})"
      @@db.execute(query)
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

    def self.get_model_object(result)
      model_name = new
      @@properties.keys.each_with_index do |key, index|
        model_name.send("#{key}=", result[index])
      end
      model_name
    end

    def record_placeholders
      (["?"] * ((@@properties.keys.size) - 1)).join(",")
    end

    def record_values
      column_names = @@properties.keys
      column_names.delete(:id)
      column_names.map {|column_name| send(column_name)}
    end

  end
end
