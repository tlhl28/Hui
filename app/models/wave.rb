class Wave < Neo4j::Rails::Model

  key :audio
  key :picture
  key :video
  key :tweet

  has_one :owner
  has_n :sharers
  has_n :comments

  validates_length_of :tweet, :with_in => 0..50, :allow_blank = true

end
