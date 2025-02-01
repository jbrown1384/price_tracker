require "spec"
require "./spec_helper"

describe Database do
  before_each do
    Database.setup
    Database.clear
  end

  describe "save price and fetch price records" do
    it "save a price record and fetches a price record" do
      product_name = "test product"
      price = 299.99

      Database.save_price(product_name, price)
      results = Database.fetch_prices(product_name)

      results.size.should eq 1
      results.first["price"].should eq 299.99
    end

    it "get multiple price history records" do
      product_name = "test product new"
      prices = [299.99, 289.99, 279.99]

      prices.each do |price|
        Database.save_price(product_name, price)
      end

      results = Database.fetch_prices(product_name)
      results.size.should eq 3
      results.map { |r| r["price"] }.should eq prices
    end

    it "returns empty array when no prices are found" do
      results = Database.fetch_prices("Non-Existent Product test")
      results.should be_empty
    end
  end
end
