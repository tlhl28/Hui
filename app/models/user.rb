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

  index :name

  has_n(:followers).from(User,:follows)
  has_n(:follows).to(User)
  has_n :channel

  has_n(:updates).to(Wave).relationship(Flowing)

  # Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  PasswordOk = /\A#{RegEmailName}#{RegDomainHead}\z/i

  validates_length_of :email, :within => 6..100
  validates_format_of :email, :with => RegEmailOk

  validates_length_of :password, :within => 6..8
  #validates_format_of :password, :with => PasswordOk

  def fresh_waves(hour=1)
	self.updates.collect { |wave| wave if wave.fresh?(hour) }
  end

  def waves_except(type)
	self.updates.find_all { |wave| wave.owner_rel.type != type }
  end

  def share_waves
	self.updates.find_all { |wave| wave.is_share? }
  end

  def comment_waves
	self.updates.find_all { |wave| wave.is_comment? }
  end

end
