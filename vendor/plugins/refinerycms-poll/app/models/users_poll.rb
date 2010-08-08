class UsersPoll < ActiveRecord::Base

  acts_as_indexed :fields => [:poll_id],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  belongs_to :poll
  belongs_to :poll_answer


end
