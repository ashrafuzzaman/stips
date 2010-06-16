class Faq < ActiveRecord::Base

  acts_as_indexed :fields => [:title, :description, :tag],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :tag
  validates_uniqueness_of :tag



end
