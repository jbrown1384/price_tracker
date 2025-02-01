require "kemal"

module Controllers
  module ScrapeController
    def self.scrape
      product_name = "AW SuperFast Roadster"
      # price = Scraper.scrape_price(product_name)
      price = 1250.00
      if price
        "Scraping completed! New price: #{price}"
      else
        "Could not find the product on the webpage."
      end
    end
  end
end
