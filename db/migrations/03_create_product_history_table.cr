module Migrations
  class CreateProductHistoryTable
    def up(db)
      db.exec <<-SQL
        CREATE TABLE IF NOT EXISTS product_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id INTEGER NOT NULL,
          price REAL NOT NULL,
          scraped_at DATETIME NOT NULL,
          FOREIGN KEY (product_id) REFERENCES products(id)
              ON DELETE CASCADE
              ON UPDATE CASCADE
        )
      SQL
      Utils::Logger.info("Created 'product history' table")
    rescue ex
      Utils::Logger.critical("Migration failed: #{ex.message}")
      raise ex
    end

    def down(db)
      db.exec "DROP TABLE IF EXISTS product_history"
      Utils::Logger.info("Dropped 'product_history' table")
    rescue ex
      Utils::Logger.critical("Rollback migration failed: #{ex.message}")
      raise ex
    end
  end
end
