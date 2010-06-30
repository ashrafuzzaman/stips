class CreateUsersPollsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :users_polls, :id => false do |t|
      t.integer :user_id
      t.integer :poll_id
      t.integer :poll_answer_id
    end
    add_index :users_polls, [:user_id, :poll_id]
  end

  def self.down
    drop_table :users_polls
  end
end
