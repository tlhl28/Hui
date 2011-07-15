class User < BaseModel

  key :email,  String
  key :name,  String
  key :nice, String
  key :password, String
  key :salt, String

  key :remember_key, String
  key :remember_key_expires_at, Time

  key :reset_password_key, String
  key :reset_password_key_expires_at, Time

  key :blacklist, Array
  key :favorites, Array
  key :follower_ids, Array
  key :following_ids, Array
  key :channel_ids, Array

  attr_protected :follower_ids, :following_ids

  def add_follower(user)
	self.follower_ids | user.id
  end
  def remove_follower(user)
	self.follower_ids.delete(user.id)
  end

  def add_following(user)
	return false if user.blacklist.include? self.id
	user.add_follower(self) 
	self.following_ids | user.id
  end
  def remove_following(user)
	user.remove_follower(self)
	self.following_ids.delete(user.id)
  end

  # Assocations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  has_many :follwers, :in => :follower_ids
  has_many :following, :in => :following_ids
  has_many :channels, :in => :channes_ids
  has_many :waves

  def publish_wave(wave)
	list = self.followers.each do |follower|
	  next if self.blacklist.include? follower.id
	  follower.waves.save(wave)
	end
	wave.following = Wave::OUT
	self.waves.save(wave)
  end

  # Validations :::::::::::::::::::::::::::::::::::::::::::::::::::::
  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  validates_length_of :email, :within => 6..100, :allow_blank => true
  validates_format_of :email, :with => RegEmailOk, :allow_blank => true

  validates_length_of :password, :within => 6..8, :allow_blank => false
  validates_length_of :password, :with => RegEmailName, :allow_blank => false

  # Action ::::::::::::::::::::::::::::::::::::::::::::::::::::::

  def remember_me(time = 1.week)
	self.remember_key_expires_at = time.from_now.utc
	self.remember_key = UUIDTools::UUID.random_create.to_s
	self.save(false)
	return {:value => self.remember_key, 
	  :expires => self.remember_key_expires_at}
  end

  def forgot_password(request, time = 1.day)
	self.reset_password_key = UUIDTools::UUID.random_create.to_s
	self.reset_password_key_expires_at = time.from_now.utc
	ChitoMailer.forgot_password(self, request).deliver if self.save
  end

  def self.login(name, password)
	user = User.find_by_name(name) || User.find_by_email(name)
	if user
	  user = nil if user.password != hash_password(password, user.salt)
	end
	user
  end

  private

  def hash_password(password, salt)
	str = password.dup
	( str << "wave_chord" << salt ) unless salt.nil?
	Digest::SHA1.hexdigest(str)
  end

  def password=(pwd)
	return if pwd.blank?
	self.salt = UUIDTools::UUID.random_create.to_s
	self.password = User.hash_password(pwd, self.salt)
  end

end

class follwers < User
end

class follwing < User
end
