require "./scraper/scraper_factory"
require "kemal"
require "./server/server"

Database.setup

brands = ["glitch"]

spawn do
  loop do
    brands.each do |brand|
      begin
        scraper = ScraperFactory.create_scraper(brand)
        scraper.scrape_and_save
        puts "Scraped and saved data for #{brand} at #{Time.utc}"
      rescue ex
        puts "Error scraping #{brand}: #{ex.message}"
      end
    end
    sleep 60.seconds
  end
end

Kemal.config.public_folder = "./src"
Kemal.run
