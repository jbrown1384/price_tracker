require "kemal"
require "./utils/logger"
require "./scraper/scraper_factory"
require "./server/server"

begin
  Database.setup
  Utils::Logger.info("database setup completed successfully")
rescue ex
  Utils::Logger.critical("database setup failed: #{ex.message}")
  exit(1)
end

brands = ["glitch"]
DEFAULT_RETRY_INTERVAL = 60

spawn do
  loop do
    brands.each do |brand|
      begin
        scraper = ScraperFactory.create_scraper(brand)
        scraper.scrape_and_save
      rescue ex
        Utils::Logger.error("scraping #{brand}: #{ex.message}")
      end

      Utils::Logger.debug("#{brand} completed. Auto-retry in #{DEFAULT_RETRY_INTERVAL} seconds")
    end
    
    sleep DEFAULT_RETRY_INTERVAL.seconds
  end
end

Kemal.config.public_folder = "./src"
Kemal.run
