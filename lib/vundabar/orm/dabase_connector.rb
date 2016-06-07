module Vundabar
  module ActiveRecord
    class Database
      def self.connect
        SQLite3::Database.new File.join "db", "app.db"
      end
    end
  end
end
