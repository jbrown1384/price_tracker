require "../database/database"

module ScraperInterface
  abstract class Base
    abstract def parse_products(html : String) : Array(ProductHistory)

    # fetch html content from the endpoint, parse products and save them
    def scrape_and_save
      Utils::Logger.debug("starting scraping...")

      html = fetch_html
      Utils::Logger.debug("fetched endpoint content from #{uri}")

      product_histories = parse_products(html)
      Utils::Logger.info("parsed #{product_histories.size} products")

      save_product_histories(product_histories)
      Utils::Logger.info("Saved #{product_histories.size} product history records")
    end

    # fetch html content from the endpoint
    private def fetch_html : String
      Utils::Logger.debug("fetching html from URI: #{uri}")
      HTTP::Client.get(uri, headers: headers).body.not_nil!
    rescue ex
      Utils::Logger.error("fetching html from #{uri}: #{ex.message}")
      raise ex
    end

    #insert product history into product_histories table
    private def save_product_histories(product_histories : Array(ProductHistory))
      product_histories.each do |history|
        Database.save_product_history(history)
      end
    end

    private def uri : String
      raise "uri must be implemented in the base class"
    end

    # deafult headers for the http request
    private def headers : HTTP::Headers
      HTTP::Headers.new
        .add("Referer", uri)
        .add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...")
    end
  end
end
