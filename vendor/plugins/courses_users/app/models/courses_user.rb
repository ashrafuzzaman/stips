class CoursesUser < ActiveRecord::Base
  include AASM

  validates_presence_of :amount_paid

  belongs_to :course
  belongs_to :user

  aasm_column :status
  aasm_initial_state :pending

  aasm_state :pending
  aasm_state :confirmed, :enter => :update_confirmed_at
  aasm_state :failed

  aasm_event :confirm do
    transitions :to => :confirmed, :from => [:pending]
  end

  aasm_event :fail do
    transitions :to => :failed, :from => [:pending]
  end

  def update_confirmed_at
    update_attribute :confirmed_at, Time.now
  end

end
