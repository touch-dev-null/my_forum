class CreateMyForumRoles < ActiveRecord::Migration
  def change
    create_table :my_forum_roles do |t|
      t.string :name
      t.string :color
      t.text   :rights
      t.timestamps null: false
    end
  end
end
