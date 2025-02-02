require "spec"
require "../spec_helper"

describe ScraperFactory do
  before_each do
    Database.setup
    Database.clear
  end

  describe "create_scraper" do
    it "creates a Glitch scraper for site 'glitch'" do
      id = 1
      site_name = "glitch"
      active_status = true

      Database.connection.exec "INSERT INTO sites (name, active_status) VALUES (?, ?)", site_name, active_status

      site = Site.new(id, site_name, active_status)
      scraper = ScraperFactory.create_scraper(site)
      scraper.is_a?(Glitch).should be_true
    end
  end
end
