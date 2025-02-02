require "sqlite3"
require "../../db/migrations/index"
require "../utils/logger"

module Database
  # class variable to hold the database connection
  @@db : DB::Database?

  DB_PATH = "sqlite3://data/scrapes.db"
  MIGRATIONS_PATH = "db/migrations"

  def self.setup
    begin 
      Utils::Logger.info("setting up database and tables")
      create_data_directory
      @@db = DB.open(DB_PATH) 
      ensure_migrations_table()
      run_migrations()
      Utils::Logger.info("Database setup and migrations completed successfully")
    rescue ex
      Utils::Logger.critical("database setup failed: #{ex.message}")
      raise ex
    end
  end

  def self.clear
    db = self.connection

    db.exec "PRAGMA foreign_keys = OFF;"

    db.exec "DELETE FROM product_history;"
    db.exec "DELETE FROM products;"
    db.exec "DELETE FROM sites;"

    db.exec "DELETE FROM sqlite_sequence WHERE name='product_history';"
    db.exec "DELETE FROM sqlite_sequence WHERE name='products';"
    db.exec "DELETE FROM sqlite_sequence WHERE name='sites';"

    db.exec "PRAGMA foreign_keys = ON;"
  end

  def self.connection : DB::Database
    @@db.not_nil!("Database connection is not established. Call Database.setup first.")
  end


  def self.fetch_price_history(product_name : String) : Array(ProductHistory)
    product_history = Set(ProductHistory).new
    
    begin
      DB.open(DB_PATH) do |db|
        start_time = Time.utc.at_beginning_of_hour
        end_time = (start_time + 1.hour) - 1.second

        db.query(
          "SELECT h.product_id, h.price, h.scraped_at 
          FROM product_history h
          LEFT JOIN products p 
            ON h.product_id = p.id
          WHERE p.name = ? 
            AND h.scraped_at BETWEEN ? AND ? 
            ORDER BY h.scraped_at ASC", 
          product_name,
          start_time,
          end_time,   
        ) do |rows|
          rows.each do
            product_id = rows.read(Int64)
            price = rows.read(Float64)
            scraped_at_raw = rows.read(String)
            scraped_at = Time.parse(scraped_at_raw, "%Y-%m-%d %H:%M:%S", Time::Location::UTC)
  
            history = ProductHistory.new(product_id, price, scraped_at)
            product_history << history
          end
        end
        product_history.to_a
      end
    rescue ex
      Utils::Logger.error("fetching prices for product: #{product_name}: #{ex.message}")
      raise ex
    end
  end

  def self.save_product_history(history : ProductHistory)
    db = self.connection
    db.exec "INSERT INTO product_history (product_id, price, scraped_at) VALUES (?, ?, ?)",
            history.product_id,
            history.price,
            history.scraped_at.to_s
            
    Utils::Logger.debug("saved product history: product id #{history.product_id}, price #{history.price}, scraped at #{history.scraped_at}")
  rescue ex
    Utils::Logger.error("saving history for product id #{history.product_id}: #{ex.message}")
  end


  def self.create_data_directory
    data_dir = File.dirname(DB_PATH.sub("sqlite3://", ""))
    Dir.mkdir(data_dir) unless Dir.exists?(data_dir)
    Utils::Logger.info("Ensured data directory exists at #{data_dir}")
  end

  def self.ensure_migrations_table()
    db = self.connection
    db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS migrations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        migration VARCHAR(255) NOT NULL UNIQUE,
        applied_at DATETIME NOT NULL
      )
    SQL
    Utils::Logger.info("Ensured migrations table exists")
  rescue ex
    Utils::Logger.critical("Failed to ensure migrations table: #{ex.message}")
    raise ex
  end

  def self.run_migrations()
    Utils::Logger.info("Running migrations")
    applied = fetch_applied_migrations()
    migrations = fetch_migration_files

    migrations.each do |migration|
      unless applied.includes?(migration)
        apply_migration(migration)
      end
    end
    Utils::Logger.info("migrations successfully executed")
  rescue ex
    Utils::Logger.critical("running migrations: #{ex.message}")
    raise ex
  end

  def self.fetch_applied_migrations() : Set(String)
    db = self.connection
    applied_migrations = Set(String).new

    db.query("SELECT migration FROM migrations") do |records|
      records.each do
        migration = records.read(String)
        applied_migrations << migration
      end
    end
  
    applied_migrations
  rescue ex
    Utils::Logger.critical("Failed to fetch applied migrations: #{ex.message}")
    raise ex
  end  

  def self.fetch_migration_files : Array(String)
    # select files that begin with a digit, followed by an underscore, and end with .cr
    Dir.entries(MIGRATIONS_PATH)
      .select { |file| file.matches?(/\A\d+_.*\.cr\z/)    }
      .sort
  rescue ex
    Utils::Logger.critical("Failed to fetch migration files: #{ex.message}")
    raise ex
  end

  def self.apply_migration(migration : String)
    db = self.connection
    
    migration_instance = case migration
    when "01_create_sites_table.cr"
      Migrations::CreateSitesTable.new
    when "02_create_products_table.cr"
      Migrations::CreateProductsTable.new
    when "03_create_product_history_table.cr"
      Migrations::CreateProductHistoryTable.new
    else
      Utils::Logger.critical("Unknown migration: #{migration}")
      raise "Unknown migration: #{migration}"
    end

    migration_instance.up(db)
    db.exec "INSERT INTO migrations (migration, applied_at) VALUES (?, ?)", migration, Time.local.to_s
    Utils::Logger.info("Applied migration: #{migration}")
  rescue ex
    Utils::Logger.critical("Failed to apply migration #{migration}: #{ex.message}")
    raise ex
  end
end
