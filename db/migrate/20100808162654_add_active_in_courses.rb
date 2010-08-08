class AddActiveInCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :active, :boolean, :default => true
  end

  def self.down
    remove_column(:courses, :active)
  end
end
