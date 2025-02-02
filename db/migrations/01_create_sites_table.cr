module Migrations
  class CreateSitesTable
    DEFAULT_SITE_NAME = "glitch"

    def up(db)
      db.exec <<-SQL
        CREATE TABLE IF NOT EXISTS sites (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          active_status BOOLEAN DEFAULT 1
        )
      SQL
      Utils::Logger.info("Created 'sites' table")

      db.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", DEFAULT_SITE_NAME, 1
      Utils::Logger.info("default site '#{DEFAULT_SITE_NAME}' created")
    rescue ex
      Utils::Logger.critical("Migration failed: #{ex.message}")
      raise ex
    end

    def down(db)
      db.exec "DROP TABLE IF EXISTS sites"
      Utils::Logger.info("Dropped 'sites' table")
    rescue ex
      Utils::Logger.critical("Rollback migration failed: #{ex.message}")
      raise ex
    end
  end
end
