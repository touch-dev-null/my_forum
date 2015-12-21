class CreateMyForumEmoticons < ActiveRecord::Migration
  def change
    create_table :my_forum_emoticons do |t|
      t.string  :file_name
      t.string  :code
      t.boolean :is_active, default: true
      t.timestamps null: false
    end
  end
end
