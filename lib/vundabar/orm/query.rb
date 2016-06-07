module Vundabar
  class Queries
    def save
      query = "INSERT INTO #{@@table} (#{table_column}) VALUES #{record_placeholders}"
      execute_querry(querry, record_values)
    end

    def execute_querry(querry, values = nil)
      return  @@db.execute querry, values if values
      @@db.execute querry
    end
  end
end
