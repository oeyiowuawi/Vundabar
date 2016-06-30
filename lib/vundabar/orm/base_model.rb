module Vundabar
  class BaseModel
    include Vundabar::ModelHelper

    def initialize(attributes = {})
      attributes.each { |column, value| send("#{column}=", value) }
    end

    class << self
      attr_reader :properties
      private(
        :make_methods,
        :build_table_fields,
        :parse_constraint,
        :type,
        :primary_key,
        :nullable,
        :get_model_object
      )
    end

    def self.to_table(name)
      @table = name.to_s
    end

    def self.property(column_name, column_properties)
      @properties ||= {}
      @properties[column_name] = column_properties
    end

    def self.create_table
      query = "CREATE TABLE IF NOT EXISTS #{table_name} "\
      "(#{build_table_fields(@properties).join(', ')})"
      Database.execute_query(query)
      make_methods
    end

    def update(attributes)
      table = self.class.table_name
      query = "UPDATE #{table} SET #{update_placeholders(attributes)}"\
      " WHERE id= ?"
      Database.execute_query(query, update_values(attributes))
    end

    def destroy
      table = self.class.table_name
      Database.execute_query "DELETE FROM #{table} WHERE id= ?", id
    end

    def save
      table = self.class.table_name
      query = if id
                "UPDATE #{table} SET #{update_placeholders} WHERE id = ?"
              else
                "INSERT INTO #{table} (#{table_columns}) VALUES "\
                "(#{record_placeholders})"
              end
      values = id ? record_values << send("id") : record_values
      Database.execute_query query, values
    end

    alias save! save

    def self.all
      query = "SELECT * FROM #{table_name} "\
        "ORDER BY id DESC"
      result = Database.execute_query query
      result.map { |row| get_model_object(row) }
    end

    def self.create(attributes)
      model_object = new(attributes)
      model_object.save
      id = Database.execute_query "SELECT last_insert_rowid()"
      model_object.id = id.first.first
      model_object
    end

    def self.count
      result = Database.execute_query "SELECT COUNT(*) FROM #{table_name}"
      result.first.first
    end

    [%w(last DESC), %w(first ASC)].each do |method_name_and_order|
      define_singleton_method((method_name_and_order[0]).to_sym) do
        query = "SELECT * FROM #{table_name} ORDER BY "\
        "id #{method_name_and_order[1]} LIMIT 1"
        row = Database.execute_query query
        get_model_object(row.first) unless row.empty?
      end
    end

    def self.find(id)
      query = "SELECT * FROM #{table_name} "\
      "WHERE id= ?"
      row = Database.execute_query(query, id).first
      get_model_object(row) if row
    end

    def self.destroy(id)
      Database.execute_query "DELETE FROM #{table_name} WHERE id= ?", id
    end

    def self.destroy_all
      Database.execute_query "DELETE FROM #{table_name}"
    end

    def self.where(query_string, value)
      data = Database.execute_query "SELECT * FROM "\
      "#{table_name} WHERE #{query_string}", value
      data.map { |row| get_model_object(row) }
    end
  end
end
