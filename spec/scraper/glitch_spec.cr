require "spec"
require "../spec_helper"

describe Glitch do
  before_each do
    Database.setup
    Database.clear
  end

  it "parse products from HTML" do
    id = 1
    site_name = "glitch"
    active_status = true
    product_name = "glitch test product"
    price = 299.99

    Database.connection.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", site_name, active_status
    Database.connection.exec "INSERT INTO products (site_id, name, active_status) VALUES (?, ?, ?)", id, product_name, active_status

    site = Site.new(id, site_name, active_status)
    scraper = ScraperFactory.create_scraper(site)
    scraper = Glitch.new(site)
    html = <<-HTML
      <div class="product-card">
        <h3>glitch test product</h3>
        <div class="price">$299.99</div>
      </div>
      <div class="product-card">
        <h3>Another Product</h3>
        <div class="price">$99.99</div>
      </div>
    HTML

    history = scraper.parse_products(html)
    history.size.should eq 1
    history.each do |product|
      product.price.should eq price
    end
  end

  it "handles HTML with no matching products" do
    id = 1
    site_name = "glitch"
    active_status = true
    product_name = "glitch test product"
    price = 299.99

    Database.connection.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", site_name, active_status
    Database.connection.exec "INSERT INTO products (site_id, name, active_status) VALUES (?, ?, ?)", id, product_name, active_status

    site = Site.new(id, site_name, active_status)
    scraper = ScraperFactory.create_scraper(site)
    scraper = Glitch.new(site)
    
    html = <<-HTML
      <div class="product-card">
        <h3>Non-Target Product</h3>
        <div class="price">$49.99</div>
      </div>
    HTML

    products = scraper.parse_products(html)
    products.should be_empty
  end
end
