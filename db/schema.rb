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

ActiveRecord::Schema.define(version: 20150508030836) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "details", id: false, force: :cascade do |t|
    t.string   "sid",          limit: 255
    t.string   "project_sid",  limit: 255
    t.string   "user_sid",     limit: 255
    t.string   "plan",         limit: 255
    t.text     "user_details", limit: 65535
    t.text     "tags",         limit: 65535
    t.boolean  "active",       limit: 1
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "details", ["sid"], name: "index_details_on_sid", unique: true, using: :btree

  create_table "matches", force: :cascade do |t|
    t.integer  "left_profile_id",           limit: 4
    t.integer  "right_profile_id",          limit: 4
    t.datetime "left_profile_matched_at"
    t.datetime "right_profile_matched_at"
    t.datetime "left_profile_notified_at"
    t.datetime "right_profile_notified_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "matches", ["left_profile_id"], name: "index_matches_on_left_profile_id", using: :btree
  add_index "matches", ["right_profile_id"], name: "index_matches_on_right_profile_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "bowtie_user_id",                  limit: 255
    t.string   "bowtie_project_id",               limit: 255
    t.text     "info",                            limit: 65535
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.datetime "last_potential_match_created_at"
    t.string   "category",                        limit: 255
    t.string   "name",                            limit: 255
    t.string   "email",                           limit: 255
    t.string   "avatar",                          limit: 255
  end

  create_table "projects", id: false, force: :cascade do |t|
    t.string   "sid",          limit: 255
    t.string   "name",         limit: 255
    t.string   "auth_domain",  limit: 255
    t.text     "user_details", limit: 65535
    t.string   "match_types",  limit: 255
    t.string   "global_match", limit: 255
    t.boolean  "active",       limit: 1
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "projects", ["sid"], name: "index_projects_on_sid", unique: true, using: :btree

  create_table "projects_users", id: false, force: :cascade do |t|
    t.string "project_id", limit: 255
    t.string "user_id",    limit: 255
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "profile_id", limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["profile_id"], name: "index_tags_on_profile_id", using: :btree

  create_table "users", id: false, force: :cascade do |t|
    t.string   "sid",            limit: 255
    t.string   "bowtie_user_id", limit: 255
    t.string   "email",          limit: 255
    t.string   "name",           limit: 255
    t.boolean  "active",         limit: 1
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "users", ["sid"], name: "index_users_on_sid", unique: true, using: :btree

end
