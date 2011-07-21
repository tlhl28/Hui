class Wave < Neo4j::Rails::Model
  key :video
  key :tweet
  key :created_at
  index :video

  has_one :owner
  has_n(:refs).from(Wave).relationship(Flowing)
  has_one(:with).to(Wave).relationship(Flowing)

  validates_length_of :comment, :within => 0..50

  def fresh?(hour=1)
	self.created_at > hour.hours.from_now
  end

  def is_comment?
	rels(:with).type == Flowing::COMMENT
  end

  def is_share?
	rels(:with)[:type] == Flowing::SHARE
  end

  def comments
	rels(:refs).find { |rel| rel.end_node if rel[:type] == Flowing::COMMENT }
  end

end
