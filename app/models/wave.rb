class Wave < Neo4j::Rails::Model
  key :video
  key :tweet
  key :created_at
  index :video

  has_one(:owner).from(User,:waves)

  # share entry or comment entry from others
  has_n(:refs).from(Wave,:with).relationship(Flowing)

  # share entry or comment entry to others
  # the type descriped in Flowing relationship
  has_one(:with).to(Wave,:refs).relationship(Flowing)

  validates_length_of :tweet, :within => 0..50

  def fresh?(hour=1)
	self.created_at > hour.hours.from_now
  end

  def is_comment?
	self.with_rel.type == Flowing::COMMENT
  end

  def is_share?
	self.with_rel[:type] == Flowing::SHARE
  end

  # find comments by relationship
  def comments
	self.refs.find_all { |ref| ref.is_comment? }.sort_by { |comment| comment.created_at }
  end

end
