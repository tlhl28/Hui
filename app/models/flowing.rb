class Flowing < Neo4j::Rails::Relationship

  SHARE = 1
  COMMENT = 2

  property :type
  property :since, :default => Time.now
  index :type

end
