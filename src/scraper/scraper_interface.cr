require "../database/database"

module ScraperInterface
  abstract class Base
    abstract def parse_products(html : String) : Array(Product)

    def scrape_and_save
      html = fetch_html
      products = parse_products(html)
      save_products(products)
    end

    private def fetch_html : String
      HTTP::Client.get(uri, headers: headers).body.not_nil!
    end

    private def save_products(products : Array(Product))
      products.each do |product|
        Database.save_price(product.name, product.price)
      end
    end

    private def uri : String
      raise "uri method must be implemented in the subclass."
    end

    private def headers : HTTP::Headers
      HTTP::Headers.new
        .add("Referer", uri)
        .add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...")
    end
  end
end
