require "spec"
require "../spec_helper"

describe Glitch do
  it "parses products correctly from valid HTML" do
    scraper = Glitch.new
    html = <<-HTML
      <div class="product-card">
        <h3>AW SuperFast Roadster</h3>
        <div class="price">$299.99</div>
      </div>
      <div class="product-card">
        <h3>Another Product</h3>
        <div class="price">$99.99</div>
      </div>
    HTML

    products = scraper.parse_products(html)
    products.size.should eq 1

    product = products.first
    product.name.should eq "AW SuperFast Roadster"
    product.price.should eq 299.99
  end

  it "handles HTML with no matching products" do
    scraper = Glitch.new
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
