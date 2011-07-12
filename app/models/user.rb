class User
	include MongoMapper::Document

	key :email,  String
	key :name,  String
	key :nice, String
	key :password, String
	key :salt, String

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

	def self.login(name, password)
		user = (User.find_by_name(name) or User.find_by_email(name))
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
		create_salt
		self.password = User.hash_password(pwd, self.salt)
	end

	def create_salt
		self.salt = UUIDTools::UUID.random_create.to_s
	end

end
