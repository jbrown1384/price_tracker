require "../brands/glitch"

module ScraperFactory
  def self.create_scraper(brand : String, endpoint : String) : ScraperInterface::Base
    case brand.downcase
    when "glitch"
      Glitch.new(endpoint)
    else
      raise "Unknown brand: #{brand}"
    end
  end
end