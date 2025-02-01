require "kemal"
require "ecr"
require "../controllers/controllers"

get "/" do
  Controllers::HomeController.index
end

post "/scrape" do
  Controllers::ScrapeController.scrape
end
