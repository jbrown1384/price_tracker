require "../scraper/base_scraper"
require "lexbor"

class Glitch < BaseScraper
  endpoint = "https://bush-daisy-tellurium.glitch.me/"
  PRODUCTS = "AW SuperFast Roadster"

  def parse_products(html : String) : Array(Product)
    parser = Lexbor::Parser.new(html)
    products = [] of Product

    parser.css(".product-card").each do |product_card|
      name_element = product_card.css("h3").first
      name = name_element ? name_element.inner_text : nil

      next unless name
      
      if name == PRODUCTS
        price_element = product_card.css(".price").first
        raw_price = price_element ? price_element.inner_text : "0"
        price = raw_price.try { |p| p.gsub(/[^\d\.]/, "").to_f } || 0.0
        products << Product.new(name, price)
      end
    end

    products
  end
end