require "../database/database"

module ScraperInterface
  abstract class Base
    abstract def parse_products(html : String) : Array(Product)

    def scrape_and_save
      Utils::Logger.debug("starting scraping...")

      html = fetch_html
      Utils::Logger.debug("fetched endpoint content from #{uri}")

      products = parse_products(html)
      Utils::Logger.info("parsed #{products.size} products")

      save_products(products)
      Utils::Logger.info("saved #{products.size} products")
    end

    private def fetch_html : String
      Utils::Logger.debug("fetching html from URI: #{uri}")
      HTTP::Client.get(uri, headers: headers).body.not_nil!
    rescue ex
      Utils::Logger.error("fetching html from #{uri}: #{ex.message}")
      raise ex
    end

    private def save_products(products : Array(Product))
      products.each do |product|
        Database.save_price(product.name, product.price)
      end
    end

    private def uri : String
      raise "uri must be implemented in the base class"
    end

    private def headers : HTTP::Headers
      HTTP::Headers.new
        .add("Referer", uri)
        .add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...")
    end
  end
end
