require "../scraper/scraper_factory"
require "http/status"

module Controllers
  module ScrapeController
    def self.scrape(context : HTTP::Server::Context)
      begin
        site_name = "glitch"
        site = fetch_site_by_name(Database.connection, site_name)
        unless site
          context.response.status_code = HTTP::Status::NOT_FOUND.code
          context.response.content_type = "application/json"
          context.response.print({ error: "site '#{site_name}' not found or inactive." }.to_json)
          return
        end

        scraper = ScraperFactory.create_scraper(site)
        scraper.scrape_and_save
        
        context.response.status_code = HTTP::Status::OK.code
        context.response.content_type = "application/json"
        context.response.print({ message: "Successfully scraped site '#{site.name}'." }.to_json)
      rescue ex
        Utils::Logger.error("Scraping failed: #{ex.message}")
        context.response.status_code = HTTP::Status::INTERNAL_SERVER_ERROR.code
        context.response.content_type = "application/json"
        context.response.print({ error: "internal server error occurred." }.to_json)
      end
    end
  end
end

def self.fetch_site_by_name(db, name : String) : Site?
  db.query("SELECT id, name, active_status FROM sites WHERE name = ? AND active_status = 1", name) do |records|
    records.each do
      id = records.read(Int64)
      name = records.read(String)
      active_status = records.read(Int32) == 1
      return Site.new(id, name, active_status)
    end
  end

  Utils::Logger.warning("no active site found for: '#{name}'")
  nil
rescue ex
  Utils::Logger.error("fetching site by name '#{name}': #{ex.message}")
  nil
end
