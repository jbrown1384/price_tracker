require "spec"
require "../spec_helper"

describe ScraperFactory do
  describe "create_scraper" do
    it "creates a Glitch scraper for brand 'glitch'" do
      site = Site.new(1, "glitch", 1)
      scraper = ScraperFactory.create_scraper(site)
      scraper.is_a?(Glitch).should be_true
    end
  end
end
