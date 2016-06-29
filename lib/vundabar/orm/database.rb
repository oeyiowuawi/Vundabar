require "sqlite3"
module Vundabar
  class Database
    def self.connect
      @db ||= SQLite3::Database.new(File.join(APP_ROOT, "db", "app.db"))
    end

    def self.execute_query(*query)
      connect.execute(*query)
    end
  end
end
