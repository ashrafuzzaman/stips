class CreatePollAnswers < ActiveRecord::Migration

  def self.up
    create_table :poll_answers do |t|
      t.string :title
      t.integer :vote, :default => 0
      t.references :poll
      t.integer :position

      t.timestamps
    end

    add_index :poll_answers, :id

#    User.find(:all).each do |user|
#      user.plugins.create(:title => "Polls", :position => (user.plugins.maximum(:position) || -1) +1)
#    end
  end

  def self.down
    UserPlugin.destroy_all({:title => "Poll Answers"})

    Page.find_all_by_link_url("/poll_answers").each do |page|
      page.link_url, page.menu_match = nil
      page.deletable = true
      page.destroy
    end
    Page.destroy_all({:link_url => "/poll_answers"})

    drop_table :poll_answers
  end

end
