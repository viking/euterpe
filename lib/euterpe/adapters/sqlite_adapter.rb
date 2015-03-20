module Euterpe
  class SqliteAdapter
    def initialize(config)
      @database = SQLite3::Database.new(config[:path])
    end

    def create_collection(name, fields)
      if tables.include?(name)
        return false
      end

      columns = ["id INTEGER PRIMARY KEY"]
      fields.each do |field|
        if field['type'] == 'string'
          columns << "#{field['name']} TEXT"
        end
      end

      @database.execute("CREATE TABLE #{name} (#{columns.join(", ")})")
      return true
    end

    def insert(name, data)
      columns = data.keys
      @database.execute("INSERT INTO #{name} (#{columns.join(", ")}) VALUES (#{Array.new(columns.length, "?").join(", ")})", data.values_at(*columns))
      @database.last_insert_row_id
    end

    def find(name, criteria = {})
      if criteria.empty?
        @database.execute("SELECT * FROM #{name}")
      else
        columns = criteria.keys
        parts = columns.collect { |k| "#{k} = ?" }
        @database.execute("SELECT * FROM #{name} WHERE #{parts.join(" AND ")}", criteria.values_at(*columns))
      end
    end

    private

    def tables
      @database.execute("SELECT name FROM sqlite_master WHERE type = 'table'").flatten
    end
  end
end
