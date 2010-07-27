class Course < ActiveRecord::Base

  acts_as_indexed :fields => [:title, :description],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :title
  validates_uniqueness_of :title



end
