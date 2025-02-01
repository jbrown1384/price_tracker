require "../scraper/base_scraper"
require "lexbor"
require "set"

class Glitch < BaseScraper
  @@endpoint = "https://bush-daisy-tellurium.glitch.me/"
  TARGET_PRODUCTS = Set(String).new(["AW SuperFast Roadster"])

  def initialize
    super(@@endpoint)
  end

  def parse_products(html : String) : Array(Product)
    parser = Lexbor::Parser.new(html)
    products = [] of Product

    parser.css(".product-card").each do |product_card|
      name_element = product_card.css("h3").first
      name = name_element ? name_element.inner_text : nil

      next unless name
      
      if TARGET_PRODUCTS.map(&.downcase).includes?(name.downcase)
        price_element = product_card.css(".price").first
        raw_price = price_element ? price_element.inner_text : "0"
        price = raw_price.try { |p| p.gsub(/[^\d\.]/, "").to_f } || 0.0
        products << Product.new(name, price)
        Utils::Logger.debug("Parsed product: #{name} with price: #{price}")
      end
    end

    products
  end
end
