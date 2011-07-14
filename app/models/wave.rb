class Wave < BaseModel

  IN = 1
  OUT = 2

  belongs_to :user
  key :user_id, ObjectId

  key :audio, ObjectId
  key :picture, ObjectId
  key :video, ObjectId
  key :tweet, String
  key :flowing, Integer, :default => IN
  key :clone_count, Integer, :defult => 0

  validates_length_of :tweet, :with_in => 0..150, :allow_blank = true

  def flowing_to(to,waves)
	#FIXME
	paginate({
	  :flowing => to,
	  :order => :created_at.asc, 
	  :per_page => waves
	})#.all( :flowing => from)
  end

  def out(waves=10)
	flowing_to(OUT,waves)
  end

  def in(waves=10)
	flowing_to(IN,waves)
  end

end
