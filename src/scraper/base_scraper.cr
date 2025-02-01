require "./scraper_interface"
require "./product.cr"

abstract class BaseScraper < ScraperInterface::Base
  property endpoint : String

  def initialize(endpoint : String)
    @endpoint = endpoint
  end

  private def uri : String
    @endpoint
  end
end
