class AddNegotiableInCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :negotiable, :boolean, :default => false
  end

  def self.down
    remove_column(:courses, :negotiable)
  end
end
