class Course < ActiveRecord::Base
  
  has_many :courses_users
  has_many :users, :through => :courses_users, :conditions => "courses_users.status = 'confirmed'"
  acts_as_indexed :fields => [:title, :description],
    :index_file => [Rails.root.to_s, "tmp", "index"]

  named_scope :active, :conditions => {:active => true}

  validates_presence_of :title
  validates_uniqueness_of :title

  def registered?(user)
    self.users.exists? user
  end

  def free?
    fee == 0
  end

end
