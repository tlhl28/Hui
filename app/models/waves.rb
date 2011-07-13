class Waves
  include MongoMapper::Document

  IN = 1
  OUT = 2

  belongs_to :user

  key :audio, ObjectId
  key :picture, ObjectId
  key :video, ObjectId
  key :tweet, String
  key :flowing, Integer
  key :is_exist, Boolean, :default => false

  #created_at and updated_at
  timestamps!

  validates_length_of :tweet, :with_in => 0..150, :allow_blank = true

  def is_deleted?()
	self.is_exist
  end

  def flowing(from,waves)
	#FIXME
	paginate({
	  :flowing => from,
	  :order => :created_at.asc, 
	  :per_page => waves
	})#.all( :flowing => from)
  end

  def out(waves=10)
	flowing(OUT,waves)
  end

  def in(waves=10)
	flowing(IN,waves)
  end

end
