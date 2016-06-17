require "sqlite3"
module Vundabar
  class Database
    def self.connect
      SQLite3::Database.new(File.join(APP_ROOT, "db", "app.db"))
    end
  end
end
