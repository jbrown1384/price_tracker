module Migrations
  class CreateProductsTable
    DEFAULT_PRODUCT_NAME = "AW SuperFast Roadster"

    def up(db)
      db.exec <<-SQL
        CREATE TABLE IF NOT EXISTS products (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          site_id INTEGER NOT NULL,
          name TEXT NOT NULL,
          active_status BOOLEAN DEFAULT 1,
          FOREIGN KEY (site_id) REFERENCES sites(id)
        )
      SQL
      Utils::Logger.info("Created 'products' table")
      
      result = db.query_one("SELECT id FROM sites WHERE name = ?", "glitch", as: Int64)

      site_id = if result
        result
      else
        Utils::Logger.critical("site 'glitch' not found in the database during migration")
      end

      Utils::Logger.info("Default site 'glitch' has ID #{site_id}")

      db.exec "INSERT INTO products (site_id, name, active_status) VALUES (?, ?, ?)", site_id, DEFAULT_PRODUCT_NAME, 1
      Utils::Logger.info("default product '#{DEFAULT_PRODUCT_NAME}' created")
    rescue ex
      Utils::Logger.critical("Migration failed: #{ex.message}")
      raise ex
    end

    def down(db)
      db.exec "DELETE FROM products WHERE name = ?", DEFAULT_PRODUCT_NAME
      Utils::Logger.info("deleted default product '#{DEFAULT_PRODUCT_NAME}'")

      db.exec "DROP TABLE IF EXISTS products"
      Utils::Logger.info("'products' table dropped successfullly")
    rescue ex
      Utils::Logger.critical("migration rollback failed: #{ex.message}")
      raise ex
    end
  end
end
