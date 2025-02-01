require "../scraper/scraper_factory"
require "http/status"

module Controllers
  module ScrapeController
    def self.scrape
      begin
        scraper = ScraperFactory.create_scraper("glitch")
        scraper.scrape_and_save
        
        HTTP::Status::OK
      rescue ex
        HTTP::Status::INTERNAL_SERVER_ERROR 
      end
    end
  end
end
