class PollAnswer < ActiveRecord::Base

  acts_as_indexed :fields => [:title],
    :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :title
  validates_uniqueness_of :title
  belongs_to :poll


end
