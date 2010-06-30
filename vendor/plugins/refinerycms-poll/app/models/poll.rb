class Poll < ActiveRecord::Base

  acts_as_indexed :fields => [:title],
    :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :poll_answers
  named_scope :active
  #named_scope :active, lambda { { :conditions => ["start_date >= ? and end_date <= ?", Date.today, Date.today] } }

  def self.active_poll(user_id)
    users_polls = UsersPoll.find_all_by_user_id(user_id, :select => :poll_id)
    polls = users_polls.count > 0 ? Poll.active.find(:all, :conditions => ["id NOT IN (?)", users_polls.collect {|up| up.poll_id } ]) : Poll.active
    polls.count > 0 ? polls.first : nil
  end
end
