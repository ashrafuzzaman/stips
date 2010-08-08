class AddMaxLimitInCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :max_limit, :integer, :default => 0
  end

  def self.down
    remove_column(:courses, :max_limit)
  end
end
