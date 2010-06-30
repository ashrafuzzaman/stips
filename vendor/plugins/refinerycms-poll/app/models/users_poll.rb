class UsersPoll < ActiveRecord::Base

  acts_as_indexed :fields => [:user_id, :poll_id],
                  :index_file => [Rails.root.to_s, "tmp", "index"]

  belongs_to :user
  belongs_to :poll
  belongs_to :poll_answer


end
