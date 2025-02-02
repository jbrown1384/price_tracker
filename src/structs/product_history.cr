struct ProductHistory
  property id : Int64?
  property product_id : Int64
  property price : Float64
  property scraped_at : Time

  # initialize ProductHistory struct with product_id, price, scraped_at
  def initialize(
    @product_id : Int64,
    @price : Float64,
    @scraped_at : Time = Time.utc
  )

  @id = nil
  end
end
