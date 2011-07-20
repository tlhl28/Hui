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


  has_n :followers
  has_n :follow
  has_n :channel

  has_n :waves

  # Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  validates_length_of :email, :within => 6..100
  validates_format_of :email, :with => RegEmailOk

  validates_length_of :password, :within => 6..8
  validates_length_of :password, :with => RegEmailName

end
