module Controllers
  module DashboardController
    def self.index(context : HTTP::Server::Context) 
      product_name = "AW SuperFast Roadster"
      product_history = Database.fetch_price_history(product_name)

      minutes_in_hour = (0..59).map(&.to_s)
      prices_by_minute = Hash(Int32, Float64?).new
      (0..59).each { |minute| prices_by_minute[minute] = nil }
      Utils::Logger.info("pre-history")
      product_history.each do |history|
        Utils::Logger.info("history found")
        begin
          mapped_minute = history.scraped_at.minute
          puts history.price
          prices_by_minute[mapped_minute] = history.price
          puts prices_by_minute[mapped_minute]
        rescue ex
          Utils::Logger.warning("parsing entry #{history.product_id}: #{ex.message}")
        end
      end
      
      x_axis_minutes = minutes_in_hour
      price_values = (0..59).map { |minute| prices_by_minute[minute] }

      rendered = ECR.render "src/views/index.ecr"
      rendered
    end
  end
end
