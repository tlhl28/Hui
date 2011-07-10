class User
  include MongoMapper::Document

  key :email,  String
  key :user_name,  String
  key :password, String

  key :follwer, Array
  key :follow, Array

  #created_at and updated_at
  timestamps!

  # Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  validates_length_of :email, :within => 6..100, :allow_blank => true
  validates_format_of :email, :with => RegEmailOk, :allow_blank => true

  validates_length_of :password, :within => 6..8, :allow_blank => false
  validates_length_of :password, :with => RegEmailName, :allow_blank => false

  # Assocations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  many :waves
end
