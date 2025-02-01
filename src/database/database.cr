require "sqlite3"

module Database
  DB_PATH = "sqlite3://data/scrapes.db"

  def self.setup
    data_dir = File.dirname(DB_PATH.sub("sqlite3://", ""))
    Dir.mkdir(data_dir) unless Dir.exists?(data_dir)

    DB.open(DB_PATH) do |db| 
      db.exec <<-SQL
        CREATE TABLE IF NOT EXISTS prices (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_name TEXT NOT NULL,
          price REAL NOT NULL,
          scraped_at DATETIME NOT NULL
        )
      SQL

      puts "Database and table set up successfully."
    end
  end

  def self.save_price(product_name : String, price : Float64)
    DB.open(DB_PATH) do |db|
      db.exec "INSERT INTO prices (product_name, price, scraped_at) VALUES (?, ?, ?)", product_name, price, Time.local
      puts "Saved price for product: #{product_name} (#{price}) at #{Time.local}"
    end
  end

  def self.fetch_prices(product_name : String) : Array(Hash(String, String | Float64))
    DB.open(DB_PATH) do |db|
      results = [] of Hash(String, String | Float64)
      start_time = Time.utc.at_beginning_of_hour
      end_time = (start_time + 1.hour) - 1.second

      db.query(
        "SELECT price, scraped_at 
        FROM prices 
        WHERE product_name = ? 
          AND scraped_at BETWEEN ? AND ?
        ORDER BY scraped_at ASC", 
        product_name,
        start_time,
        end_time, 
      ) do |rs|
        rs.each do
          results << {"price" => rs.read(Float64), "scraped_at" => rs.read(String)}
        end
      end

      puts "Fetched #{results.size} price records for product: #{product_name}."
      results
    end
  end
end
