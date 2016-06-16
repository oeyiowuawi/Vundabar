  module Vundabar
    class BaseModel < Vundabar::ModelHelper
      def initialize(attributes = {})
        attributes.each {|column, value| send("#{column}=", value)}
      end

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

      alias save! save

      def self.all
        query = "SELECT #{@@properties.keys.join(', ')} FROM #{@@table} ORDER BY id DESC"
        result = @@db.execute query
        result.map{|row| get_model_object(row)}
      end

      def self.create(attributes)
        object = new(attributes)
        object.save
        id = @@db.execute "SELECT last_insert_rowid()"
        object.id = id.first.first
        object
      end

      def self.last
        query = "SELECT * FROM #{@@table} ORDER BY id DESC LIMIT 1"
        row = @@db.execute query
        return nil if row.empty?
        get_model_object(row.first)
      end

      def self.first
        query = "SELECT * FROM #{@@table} ORDER BY id ASC LIMIT 1"
        row = @@db.execute query
        return nil if row.empty?
        get_model_object(row.first)
      end

      def self.count
        result = @@db.execute "SELECT COUNT(*) FROM #{@@table}"
        result.first.first
      end

      def self.find(id)
        query = "SELECT #{@@properties.keys.join(', ')} FROM #{@@table} WHERE id= ?"
        row = @@db.execute(query, id).first
        return nil unless row
        get_model_object(row)
      end

      def update(attributes)
        query = "UPDATE #{@@table} SET #{update_placeholders(attributes)} WHERE id= ?"
        @@db.execute(query, update_values(attributes))
      end

      def destroy
        query = "DELETE FROM #{@@table} WHERE id= ?"
        @@db.execute(query, id)
      end

      def self.destroy(id)
        query = "DELETE FROM #{@@table} WHERE id= ?"
        @@db.execute(query, id)
      end

      def self.destroy_all
        @@db.execute "DELETE FROM #{@@table}"
      end

      def self.where(querry_string, value)
        data = @@db.execute "SELECT #{@@properties.keys.join(', ')} FROM "\
        "#{@@table} WHERE #{querry_string}", value
        data.map {|row| get_model_object(row)}
      end
    end
  end
