class CreateCourses < ActiveRecord::Migration

  def self.up
    create_table :courses do |t|
      t.string :title
      t.date :start_date
      t.text :description
      t.integer :position

      t.timestamps
    end

    add_index :courses, :id

    load(Rails.root.join('db', 'seeds', 'courses.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:title => "Courses"})

    Page.find_all_by_link_url("/courses").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/courses"})

    drop_table :courses
  end

end
