require "kemal"
require "../brands/glitch"

get "/" do
  product_name = "AW SuperFast Roadster"
  raw_data = Database.fetch_prices(product_name)
  minutes_in_hour = (0..59).to_a.map(&.to_s)

  prices_by_minute = {} of Int32 => Float64 | Nil
  (0..59).each do |minute| 
    prices_by_minute[minute] = nil
  end

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
  price_values = (0..59).map { |minute| prices_by_minute[minute] || nil}

  <<-HTML
  <!DOCTYPE html>
  <html>
    <head>
      <title>AW SuperFast Roadster Price Tracker</title>
      <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
    </head>
    <body>
      <h1>AW SuperFast Roadster Price Tracker</h1>
      <canvas id="priceGraph" width="800" height="400"></canvas>
      <button onclick="triggerScrape()">Scrape Latest Price</button>

      <script>
        const xAxisMinutes = #{x_axis_minutes};
        const prices = #{price_values.to_json};

        const data = {
          labels: xAxisMinutes,
          datasets: [{
            label: 'Price ($)', 
            data: prices,
            borderColor: 'rgba(75, 192, 192, 1)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderWidth: 2,
            pointRadius: 3,
            spanGaps: true
          }]
        };

        const config = {
          type: 'line',
          data: data,
          options: {
            responsive: true,
            plugins: {
              legend: {
                display: true,
                position: 'top'
              },
              tooltip: {
                enabled: true
              }
            },
            scales: {
              x: {
                title: {
                  display: true,
                  text: "Minutes of the Hour"
                }
              },
              y: {
                ticks: {
                  callback: function(value) {
                    return `$${value}`;
                  }
                },
                title: {
                  display: true,
                  text: "Price ($)"
                }
              }
            }
          }
        };

        // Render the chart
        const ctx = document.getElementById('priceGraph').getContext('2d');
        new Chart(ctx, config);

        // Trigger backend scraping on button click and refresh the page
        async function triggerScrape() {
          const response = await fetch("/scrape", { method: "POST" });
          location.reload(); // Refresh to update the chart with new data
        }
      </script>
    </body>
  </html>
  HTML
end


# post "/scrape" do
#   # Scrape the price of AW SuperFast Roadster
#   product_name = "AW SuperFast Roadster"
#   price = Scraper.scrape_price(product_name)
#   if price
#     "Scraping completed! New price: #{price}"
#   else
#     "Could not find the product on the webpage."
#   end
# end
