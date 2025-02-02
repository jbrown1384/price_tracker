require "../scraper/base_scraper"
require "lexbor"
require "set"

class Glitch < BaseScraper
  property site : Site
  property active_products : Array(Product)

  @@endpoint = "https://bush-daisy-tellurium.glitch.me/"

  def initialize(site : Site)
    super(@@endpoint)
    @site = site
    @active_products = fetch_active_products
  end

  def fetch_active_products : Array(Product)
    site.active_products(Database.connection)
  end

  def parse_products(html : String) : Array(ProductHistory)
    parser = Lexbor::Parser.new(html)
    product_histories = [] of ProductHistory

    parser.css(".product-card").each do |product_card|
      name_element = product_card.css("h3").first
      name = name_element ? name_element.inner_text : nil

      next unless name
      
      product = @active_products.find { |active_product| active_product.name.downcase == name.downcase }
      next unless product

      price_element = product_card.css(".price").first
      raw_price = price_element ? price_element.inner_text : "0"
      price = raw_price.try { |p| p.gsub(/[^\d\.]/, "").to_f } || 0.0
      product_history = ProductHistory.new(
        product.id,
        price,
        Time.utc
      )
      product_histories << product_history
      
      Utils::Logger.debug("parsed product history with product id: #{product.id}, Price: #{price}")
    end

    product_histories
  end
end
