class CreateMyForumUserGroups < ActiveRecord::Migration
  def change
    create_table :my_forum_user_groups do |t|
      t.string :name
      t.string :html_color
      t.boolean :default, default: false
      t.timestamps null: false
    end

    MyForum::UserGroup.create!(name: 'Guests')
    MyForum::UserGroup.create!(name: 'Member', default: true)
    MyForum::UserGroup.create!(name: 'Moderator')
    MyForum::UserGroup.create!(name: 'Admin')
  end
end
