require "sqlite3"
require "../database/database"
require "./product"

struct Site
  property id : Int64
  property name : String
  property active_status : Bool

  # initialize Site struct with id, name, active_status
  def initialize(
    @id : Int64,
    @name : String,
    @active_status : Bool = true
  )
  end

  # retrieve active products for the site
  def active_products(db) : Array(Product)
    active_products = Set(Product).new

    db.query("SELECT id, site_id, name, active_status FROM products WHERE site_id = ? AND active_status = 1", @id) do |results|
      results.each do
        id = results.read(Int64)
        site_id = results.read(Int64)
        name = results.read(String)
        active_status = results.read(Int32) == 1  # Assuming active_status is stored as INTEGER (1 = true)
    
        product = Product.new(id, site_id, name, active_status)
        active_products << product
      end
    end

    # convert active products as an array from a set
    active_products.to_a
  rescue ex
    Utils::Logger.error("Failed to retrieve active products for site '#{@name}': #{ex.message}")
    [] of Product
  end
end

def fetch_active_sites(db) : Array(Site)
  active_sites = Set(Site).new

  db.query("SELECT id, name, active_status FROM sites WHERE active_status = 1") do |result_set|
    result_set.each do
      id = result_set.read(Int64)
      name = result_set.read(String)
      active_status = result_set.read(Int32) == 1
  
      site = Site.new(id, name, active_status)
      active_sites << site
    end
  end
  
  active_sites.to_a
end
