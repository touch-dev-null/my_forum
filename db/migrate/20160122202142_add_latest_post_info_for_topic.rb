class AddLatestPostInfoForTopic < ActiveRecord::Migration
  def change
    add_column :my_forum_topics, :latest_post_created_at,   :datetime
    add_column :my_forum_topics, :latest_post_login,        :string
    add_column :my_forum_topics, :latest_post_user_id,      :integer

    count = MyForum::Topic.count
    MyForum::Topic.find_in_batches do |group|
      group.each do |topic|
        puts "#{count-=1} Try to update #{topic.name}"
        latest_post = topic.posts.last
        latest_post_user = latest_post.user
        next unless latest_post_user

        topic.update(
          latest_post_created_at: latest_post.created_at,
          latest_post_login:      latest_post_user.login,
          latest_post_user_id:    latest_post_user.id
        )
      end
    end

  end
end
