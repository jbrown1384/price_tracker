require "./scraper/scraper_factory"
require "kemal"
require "./server/server"

Database.setup

brands = {
  "glitch" => "https://bush-daisy-tellurium.glitch.me/",
  # "another_brand" => "https://example.com/",
}

spawn do
  loop do
    brands.each do |brand, endpoint|
      begin
        scraper = ScraperFactory.create_scraper(brand, endpoint)
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
