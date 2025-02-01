require "./scraper"
require "./server"

spawn do
  product_name = "AW SuperFast Roadster"
  loop do
    begin
      puts "Starting scrape for #{product_name} at #{Time.utc}"
      price = Scraper.scrape_price(product_name)
      puts "Scraped price: #{price} at #{Time.utc}"
    rescue ex
      puts "Error during scraping: #{ex.message}"
    end
    sleep 60.seconds
  end
end

Kemal.config.public_folder = "./src"
Kemal.run
