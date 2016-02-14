class AddEditedByForPost < ActiveRecord::Migration
  def change
    add_column :my_forum_posts, :edited_by, :string, default: nil
  end
end
