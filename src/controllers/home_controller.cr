require "kemal"
require "ecr"
require "ecr/macros"

module Controllers
  module HomeController
    def self.index
      product_name = "AW SuperFast Roadster"
      raw_data = Database.fetch_prices(product_name)

      minutes_in_hour = (0..59).map(&.to_s)
      prices_by_minute = Hash(Int32, Float64?).new
      (0..59).each { |minute| prices_by_minute[minute] = nil }

      raw_data.each do |entry|
        scraped_at = Time.parse(
          entry["scraped_at"].to_s,
          "%Y-%m-%d %H:%M:%S.%L",
          Time::Location::UTC
        )
        mapped_minute = scraped_at.minute
        price = entry["price"].to_f
        prices_by_minute[mapped_minute] = price
      end

      x_axis_minutes = minutes_in_hour
      price_values = (0..59).map { |minute| prices_by_minute[minute] }

      rendered = ECR.render "src/views/index.ecr"

      rendered
    end
  end
end
