class AddUserInfoInCoursesUsers < ActiveRecord::Migration
  def self.up
    change_table :courses_users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.index :first_name
      t.index :last_name
    end
  end

  def self.down
    change_table :courses_users do |t|
      t.remove_index :first_name
      t.remove_index :last_name

      t.remove :first_name
      t.remove :last_name
      t.remove :email
    end
  end
end
