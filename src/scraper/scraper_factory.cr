require "../brands/glitch"

module ScraperFactory
  def self.create_scraper(brand : String) : ScraperInterface::Base
    case brand.downcase
      when "glitch"
        Glitch.new
    else
      raise "Unknown brand: #{brand}"
    end
  end
end
