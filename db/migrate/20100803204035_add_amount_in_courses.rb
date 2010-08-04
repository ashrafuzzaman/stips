class AddAmountInCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :fee, :float, :default => 0
  end

  def self.down
    remove_column(:courses, :fee)
  end
end
