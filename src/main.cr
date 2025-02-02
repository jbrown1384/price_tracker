require "kemal"
require "./utils/logger"
require "./structs/site"
require "./scraper/scraper_factory"
require "./routes/routes"

begin
  # setup database and run any migrations if necessary
  Database.setup
  Utils::Logger.info("database setup completed successfully")
rescue ex
  Utils::Logger.critical("database setup failed: #{ex.message}")
  exit(1)
end

DEFAULT_RETRY_INTERVAL = 60

# fetch all active sites from the database
active_sites = fetch_active_sites(Database.connection)

spawn do
  loop do
    active_sites.each do |active_site|
      begin
        # pass site to the scraper factory to instantiate matching scraper
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

# fetch all active sites from the database
def fetch_active_sites(db) : Array(Site)
  active_sites = Set(Site).new

  db.query("SELECT id, name, active_status FROM sites WHERE active_status = 1") do |result_set|
    result_set.each do
      id = result_set.read(Int64)
      name = result_set.read(String)
      active_status = result_set.read(Int32) == 1
      
      # set active site to Site struct
      site = Site.new(id, name, active_status)
      active_sites << site
    end
  end
  
  # convert active sites as an array from a set
  active_sites.to_a
end

# set up public directory for static files
Kemal.config.public_folder = "./src"

# start the Kemal server
Kemal.run
