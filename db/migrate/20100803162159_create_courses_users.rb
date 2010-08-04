class CreateCoursesUsers < ActiveRecord::Migration

  def self.up
    create_table :courses_users do |t|
      t.float :amount_paid
      t.datetime :confirmed_at
      t.integer :course_id
      t.integer :user_id
      t.string :status
      t.string :token
      t.string :params

      t.timestamps
    end

    add_index :courses_users, :id

    load(Rails.root.join('db', 'seeds', 'courses_users.rb'))
  end

  def self.down
    UserPlugin.destroy_all({:title => "Courses Users"})

#    Page.find_all_by_link_url("/courses_users").each do |page|
#      page.link_url, page.menu_match = nil
#      page.deletable = true
#      page.destroy
#    end
#    Page.destroy_all({:link_url => "/courses_users"})

    remove_index :courses_users, :id
    drop_table :courses_users
  end

end
