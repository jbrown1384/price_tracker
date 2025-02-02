require "../sites/glitch"

module ScraperFactory
  def self.create_scraper(site : Site) : ScraperInterface::Base
    Utils::Logger.info("creating scraper for site: #{site.name}")
    
    case site.name.downcase
      when "glitch"
        Glitch.new(site)
      else
        raise "Unknown site: #{site.name}"
      end
  rescue ex
    Utils::Logger.critical("initializing scraper for #{site.name}: #{ex.message}")
    raise ex
  end
end
