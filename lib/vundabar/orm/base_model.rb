  module Vundabar
    class BaseModel < Vundabar::ModelHelper
      def save
        query = "INSERT INTO #{@@table} (#{table_columns}) VALUES (#{record_placeholders})"
        execute_querry(query, record_values)
      end

      def self.all
        query = "SELECT #{@@properties.keys.join(', ')} FROM #{@@table} ORDER BY id DESC"
        result = execute_query query
        get_model_object(result)
      end

      def execute_query(query, values = nil)
        return  @@db.execute query, values if values
        @@db.execute query
      end
    end
  end
