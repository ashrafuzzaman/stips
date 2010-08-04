class Course < ActiveRecord::Base
  
  has_many :courses_users
  has_many :users, :through => :courses_users
  acts_as_indexed :fields => [:title, :description],
    :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :title
  validates_uniqueness_of :title

  def registered?(user)
    self.users.exists? users
  end

end
