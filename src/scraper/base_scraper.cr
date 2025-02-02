require "./scraper_interface"
require "../structs/product"
require "../structs/product_history"
require "../structs/site"

abstract class BaseScraper < ScraperInterface::Base
  property endpoint : String

  def initialize(endpoint : String)
    @endpoint = endpoint
  end

  private def uri : String
    @endpoint
  end
end
