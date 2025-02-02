require "kemal"
require "ecr"
require "../controllers/controllers"

get "/" do |context|
  Utils::Logger.info("Received GET request for '/'")
  Controllers::DashboardController.index(context)
rescue ex
  Utils::Logger.error("Error handling GET '/': #{ex.message}")
  "Internal Server Error"
end

post "/scrape" do |context|
  Utils::Logger.info("Received POST request for '/scrape'")
  Controllers::ScrapeController.scrape(context)
rescue ex
  Utils::Logger.error("Error handling POST '/scrape': #{ex.message}")
  context.response.status_code = HTTP::Status::INTERNAL_SERVER_ERROR.code
  { error: "Internal Server Error" }.to_json
end
