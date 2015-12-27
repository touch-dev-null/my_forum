require_dependency "my_forum/application_controller"

module MyForum
  class WelcomeController < ApplicationController
    def index
      @forum_categories = if current_user && current_user.is_admin?
                            Category.includes(:forums)
                          else
                            @forum_categories = Category.includes(:forums, :user_groups).
                              reject{|category| (category.user_groups.map(&:name) & (current_user_groups)).blank? }
                          end


      # Don`r forget permissions
      available_forum_ids = MyForum::Forum.where(category_id: @forum_categories.map(&:id)).pluck(:id)
      @recent_posts = if available_forum_ids.blank?
                        []
                      else
                        Topic.find_by_sql("
                          SELECT posts.id, posts.user_id, posts.text, posts.topic_id, posts.updated_at, topics.name as topic_name, topics.forum_id, topics.deleted FROM my_forum_posts AS posts
                          LEFT JOIN my_forum_topics AS topics ON posts.topic_id = topics.id
                          LEFT JOIN my_forum_forums AS forums ON forums.id = topics.forum_id
                          WHERE posts.id IN (SELECT MAX(id) FROM my_forum_posts GROUP BY topic_id) AND posts.is_deleted IS FALSE AND topics.deleted IS FALSE AND forums.id IN (#{available_forum_ids.join(',')})
                          ORDER BY posts.id DESC LIMIT 10
                        ")
                      end

    end
  end
end
