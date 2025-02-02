require "spec"
require "./spec_helper"

describe Database do
  before_each do
    Database.setup
    Database.clear
  end

  describe "save price and fetch price records" do
    it "save a price record and fetches a price record" do
      id = 1
      site_name = "test site"
      active_status = true
      product_name = "test product new"
      price = 299.99

      Database.connection.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", site_name, active_status
      Database.connection.exec "INSERT INTO products (site_id, name, active_status) VALUES (?, ?, ?)", id, product_name, active_status

      product_history = ProductHistory.new(id, price, Time.utc)
      Database.save_product_history(product_history)

      history = Database.fetch_price_history(product_name)
      history.size.should eq 1
      history.each do |product|
        product.price.should eq price
      end
    end

    it "get multiple price history records" do
      id = 1
      site_name = "test site"
      active_status = true
      product_name = "test product new"
      prices = [299.99, 289.99, 279.99]

      Database.connection.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", site_name, active_status
      Database.connection.exec "INSERT INTO products (site_id, name, active_status) VALUES (?, ?, ?)", id, product_name, active_status

      prices.each do |price|
        product_history = ProductHistory.new(id, price, Time.utc)
        Database.save_product_history(product_history)
      end

      history = Database.fetch_price_history(product_name)
      history.size.should eq 3
    end

    it "returns empty array when no prices are found" do
      id = 1
      site_name = "test site"
      active_status = true
      product_name = "test product new"
      price = 299.99

      Database.connection.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", site_name, active_status
      Database.connection.exec "INSERT INTO products (site_id, name, active_status) VALUES (?, ?, ?)", id, product_name, active_status

      product_history = ProductHistory.new(id, price, Time.utc)
      Database.save_product_history(product_history)

      history = Database.fetch_price_history("Non-Existent Product test")      
      history.should be_empty
    end
  end
end
