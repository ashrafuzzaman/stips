class AddUserIdentifierInUsersPolls < ActiveRecord::Migration
  def self.up
    change_table :users_polls do |t|
      t.string :user_identifier
      t.remove :user_id
      t.index :user_identifier
    end
  end

  def self.down
    change_table :users_polls do |t|
      t.integer :user_id
      t.remove :user_identifier
      t.remove_index :user_identifier
    end
  end
end
