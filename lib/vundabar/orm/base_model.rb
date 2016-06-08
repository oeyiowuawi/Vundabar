  module Vundabar
    class BaseModel < Vundabar::ModelHelper
      def save
        query = "INSERT INTO #{@@table} (#{table_columns}) VALUES (#{record_placeholders})"
        execute_querry(query, record_values)
      end


      def execute_querry(query, values = nil)
        return  @@db.execute query, values if values
        @@db.execute query
      end
    end
  end
