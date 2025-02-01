require "../brands/glitch"

module ScraperFactory
  def self.create_scraper(brand : String) : ScraperInterface::Base
    case brand.downcase
    when "glitch"
      Utils::Logger.info("creating scraper for brand: #{brand}")
      Glitch.new
    else
      Utils::Logger.error("could not find a scraper for brand: #{brand}")
      raise "Unknown brand: #{brand}"
    end
  rescue ex
    Utils::Logger.critical("initializing scraper for #{brand}: #{ex.message}")
    raise ex
  end
end
