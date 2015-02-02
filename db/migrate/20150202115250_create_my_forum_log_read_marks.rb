class CreateMyForumLogReadMarks < ActiveRecord::Migration
  def change
    create_table :my_forum_log_read_marks do |t|
      t.integer :user_id
      t.integer :topic_id
      t.integer :post_id
      t.timestamps
    end
  end
end
