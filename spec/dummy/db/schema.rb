# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150227210814) do

  create_table "my_forum_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_category_permissions", force: :cascade do |t|
    t.integer  "user_group_id"
    t.integer  "category_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "my_forum_forums", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "description"
    t.integer  "topics_count"
    t.integer  "posts_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_log_read_marks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "forum_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_private_messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    default: false
    t.boolean  "recipient_deleted", default: false
    t.boolean  "unread",            default: true
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "my_forum_roles", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.text     "rights"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_topics", force: :cascade do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.integer  "latest_post_id"
    t.string   "name"
    t.string   "description"
    t.integer  "views"
    t.integer  "posts_count",    default: 0
    t.boolean  "pinned",         default: false
    t.boolean  "closed",         default: false
    t.boolean  "deleted",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_user_group_links", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "user_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_user_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "html_color"
    t.boolean  "default",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "my_forum_users", force: :cascade do |t|
    t.string   "login"
    t.string   "password"
    t.string   "salt"
    t.string   "email"
    t.integer  "posts_count"
    t.boolean  "is_admin",           default: false
    t.boolean  "is_moderator",       default: false
    t.boolean  "is_deleted",         default: false
    t.boolean  "permanently_banned", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_logged_in"
  end

end
