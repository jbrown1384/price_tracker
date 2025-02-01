require "kemal"
require "ecr"
require "../controllers/controllers"

get "/" do
  Utils::Logger.info("Received GET request for '/'")
  Controllers::DashboardController.index
rescue ex
  Utils::Logger.error("Error handling GET '/': #{ex.message}")
  "Internal Server Error"
end

post "/scrape" do
  Utils::Logger.info("Received POST request for '/scrape'")
  Controllers::ScrapeController.scrape
rescue ex
  Utils::Logger.error("Error handling POST '/scrape': #{ex.message}")
  HTTP::Status::INTERNAL_SERVER_ERROR
end
