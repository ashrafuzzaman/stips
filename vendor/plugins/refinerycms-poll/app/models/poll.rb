class Poll < ActiveRecord::Base

  acts_as_indexed :fields => [:title],
    :index_file => [Rails.root.to_s, "tmp", "index"]

  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :poll_answers

  def self.active_poll(user_identifier)
    users_polls = UsersPoll.find_all_by_user_identifier(user_identifier, :select => :poll_id)
    polls = users_polls.length > 0 ? Poll.find(:all, :conditions => ["id NOT IN (?)", users_polls.collect {|up| up.poll_id } ]) : Poll.all
    polls.length > 0 ? polls.first : nil
  end

  def total_vote
    poll_answers.sum(:vote)
  end
end
