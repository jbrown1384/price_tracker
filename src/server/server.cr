require "kemal"
require "ecr"
require "../controllers/controllers"

get "/" do
  Controllers::DashboardController.index
end

post "/scrape" do
  Controllers::ScrapeController.scrape
end
