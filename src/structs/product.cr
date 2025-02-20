struct Product
  property id : Int64
  property site_id : Int64
  property name : String
  property active_status : Bool

  # initialize Product struct with id, site_id, name, active_status
  def initialize(
    @id : Int64,
    @site_id : Int64,
    @name : String,
    @active_status : Bool = true
  )
  end
end
