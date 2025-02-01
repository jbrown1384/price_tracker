require "spec"
require "../spec_helper"

describe ScraperFactory do
  describe "create_scraper" do
    it "creates a Glitch scraper for brand 'glitch'" do
      scraper = ScraperFactory.create_scraper("glitch")
      scraper.is_a?(Glitch).should be_true
    end
  end
end
