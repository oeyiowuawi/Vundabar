module Vundabar
  class ModelHelper
    def save
      table = self.class.table_name
      query = if id
                "UPDATE #{table} SET #{update_placeholders} WHERE id = ?"
              else
                "INSERT INTO #{table} (#{table_columns}) VALUES "\
                "(#{record_placeholders})"
              end
      values = id ? record_values << send("id") : record_values
      self.class.db.execute query, values
    end

    alias save! save

    def self.all
      query = "SELECT * FROM #{table_name} "\
        "ORDER BY id DESC"
      result = db.execute query
      result.map { |row| get_model_object(row) }
    end

    def self.create(attributes)
      object = new(attributes)
      object.save
      id = db.execute "SELECT last_insert_rowid()"
      object.id = id.first.first
      object
    end

    def self.count
      result = db.execute "SELECT COUNT(*) FROM #{table_name}"
      result.first.first
    end

    [%w(last DESC), %w(first ASC)].each do |method_name_and_order|
      define_singleton_method((method_name_and_order[0]).to_s.to_sym) do
        query = "SELECT * FROM #{table_name} ORDER BY "\
        "id #{method_name_and_order[1]} LIMIT 1"
        row = db.execute query
        get_model_object(row.first) unless row.empty?
      end
    end

    def self.find(id)
      query = "SELECT * FROM #{table_name} "\
      "WHERE id= ?"
      row = db.execute(query, id).first
      get_model_object(row) if row
    end

    def update(attributes)
      table = self.class.table_name
      query = "UPDATE #{table} SET #{update_placeholders(attributes)}"\
      " WHERE id= ?"
      self.class.db.execute(query, update_values(attributes))
    end

    def destroy
      table = self.class.table_name
      self.class.db.execute "DELETE FROM #{table} WHERE id= ?", id
    end

    def self.destroy(id)
      db.execute "DELETE FROM #{table_name} WHERE id= ?", id
    end

    def self.destroy_all
      db.execute "DELETE FROM #{table_name}"
    end

    def self.where(querry_string, value)
      data = db.execute "SELECT * FROM "\
      "#{table_name} WHERE #{querry_string}", value
      data.map { |row| get_model_object(row) }
    end
  end
end
