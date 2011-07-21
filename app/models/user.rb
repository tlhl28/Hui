class User < Neo4j::Rails::Model
  property :email
  property :name
  property :nice
  property :password
  property :salt

  property :remember_property
  property :remember_property_expires_at

  property :reset_password_property
  property :reset_password_property_expires_at

  property :created_at

  has_n(:followers).from(User)
  has_n(:follows).to(User)
  has_n :channel

  has_n(:waves).to(Wave).relationship(Flowing)

  # Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  validates_length_of :email, :within => 6..100
  validates_format_of :email, :with => RegEmailOk

  validates_length_of :password, :within => 6..8
  validates_length_of :password, :with => RegEmailName


  def fresh_waves(hour=1)
	self.waves.collect { |wave| wave if wave.fresh?(hour) }
  end

  def get_waves(type)
	rels(:waves).find { |rel| rel.end_node if rel.type == type) }
  end

  def waves_except(type)
	rels(:waves).find { |rel| rel.end_node if rel.type != type) }
  end

  def share_waves
	get_waves(Flowing::SHARE)
  end

  def comment_waves
	get_waves(Flowing::COMMENT)
  end

end
