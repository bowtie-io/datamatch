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

ActiveRecord::Schema.define(version: 20150430171005) do
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
  end

  create_table "tags", force: :cascade do |t|
    t.integer  "profile_id", limit: 4
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["name"], name: "index_tags_on_name", using: :btree
  add_index "tags", ["profile_id"], name: "index_tags_on_profile_id", using: :btree
end
