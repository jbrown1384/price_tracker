require "kemal"
require "./utils/logger"
require "./structs/site"
require "./scraper/scraper_factory"
require "./server/server"

begin
  Database.setup
  Utils::Logger.info("database setup completed successfully")
rescue ex
  Utils::Logger.critical("database setup failed: #{ex.message}")
  exit(1)
end

DEFAULT_RETRY_INTERVAL = 60
active_sites = fetch_active_sites(Database.connection)

spawn do
  loop do
    active_sites.each do |active_site|
      begin
        scraper = ScraperFactory.create_scraper(active_site)
        scraper.scrape_and_save
      rescue ex
        Utils::Logger.error("scraping #{active_site.name}: #{ex.message}")
      end

      Utils::Logger.debug("#{active_site.name} completed. Auto-retry in #{DEFAULT_RETRY_INTERVAL} seconds")
    end
    
    sleep DEFAULT_RETRY_INTERVAL.seconds
  end
end

def fetch_active_sites(db) : Array(Site)
  active_sites = Set(Site).new

  db.query("SELECT id, name, active_status FROM sites WHERE active_status = 1") do |result_set|
    result_set.each do
      id = result_set.read(Int64)
      name = result_set.read(String)
      active_status = result_set.read(Int32) == 1
  
      site = Site.new(id, name, active_status)
      active_sites << site
    end
  end
  
  active_sites.to_a
end

Kemal.config.public_folder = "./src"
Kemal.run
