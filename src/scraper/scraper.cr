require "./database"
require "http/client"
require "lexbor"

module Scraper
  URL = "https://bush-daisy-tellurium.glitch.me/"
  HEADERS = HTTP::Headers.new.tap do |headers|
    headers["Referer"] = "https://bush-daisy-tellurium.glitch.me/"
    headers["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"
  end
  
  def self.scrape_price(product_name : String) : (String | Nil)
    Database.setup

    response = HTTP::Client.get(URL, headers: HEADERS).body
    html_parser = Lexbor::Parser.new(response)

    products_found = 0
    html_parser.css(".product-card").each do |product_card|
      products_found += 1

      name_element = product_card.css("h3").first
      name = name_element ? name_element.inner_text : nil
      if name.nil?
        next
      end

      puts "Product Name Found: #{name}"
      if name == product_name
        price_element = product_card.css(".price").first
        raw_price = price_element ? price_element.inner_text : "0"
        price = raw_price.try { |p| p.gsub(/[^\d\.]/, "").to_f } || 0.0
        Database.save_price(name, price)
        puts "Name: #{name}: Price Found: $#{price}"
        return price_element ? price_element.inner_text : nil
      end
    end

    if products_found == 0
      puts "No `products` found!"
    else
      puts "Processed #{products_found} `.product-card` elements without a match."
    end

    nil
  end
end