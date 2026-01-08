# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_01_08_104730) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "account_id"
    t.string "platform"
    t.string "username"
    t.integer "likes"
    t.integer "clicks"
    t.integer "comments"
    t.integer "dislikes"
    t.integer "posts_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "platform_user_id"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "token_expires_at"
  end

  create_table "platforms", force: :cascade do |t|
    t.string "platform_name"
    t.string "icon_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stats", force: :cascade do |t|
    t.bigint "account_id"
    t.integer "followers"
    t.integer "likes"
    t.integer "posts"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_stats_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "stats", "accounts"
end
