class BaseModel
  include MongoMapper::Document
  before_destroy :special_destroy

  key :is_deleted, Boolean, :default => false
  #created_at and updated_at
  timestamps!

  def is_deleted?()
	self.is_deleted
  end

  private 
  def special_destroy
	self.is_deleted = true
	false
  end

end
