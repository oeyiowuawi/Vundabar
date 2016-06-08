  module Vundabar
    class BaseModel < Vundabar::ModelHelper
      def save
        query = "INSERT INTO #{@@table} (#{table_columns}) VALUES (#{record_placeholders})"
        @@db.execute query, record_values
      end

      def self.all
        query = "SELECT #{@@properties.keys.join(', ')} FROM #{@@table} ORDER BY id DESC"
        result = @@db.execute query
        result.map{|row| get_model_object(row)}
      end

      def self.find(id)
        query = "SELECT #{@@properties.keys.join(', ')} FROM #{@@table} WHERE id= ?"
        row = @@db.execute(query, id).first
        get_model_object(row)
      end
    end
  end
