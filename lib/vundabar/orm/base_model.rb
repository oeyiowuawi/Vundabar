  module Vundabar
    class BaseModel < Vundabar::ModelHelper
      def save
        query = if id
                  "UPDATE #{@@table} SET #{update_placeholders} WHERE id = ?"
                else
                  "INSERT INTO #{@@table} (#{table_columns}) VALUES "\
                  "(#{record_placeholders})"
                end
        values = id ? record_values << send("id") : record_values
        @@db.execute query, values
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

      def update(attributes)
        query = "UPDATE #{@@table} SET #{update_placeholders(attributes)} WHERE id= ?"
        @@db.execute(query, update_values(attributes))
      end
    end
  end
