# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_10_032704) do

  create_table "admin_chats", force: :cascade do |t|
    t.integer "autho_id"
    t.integer "group_id"
    t.text "message"
    t.string "url"
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_groups", force: :cascade do |t|
    t.string "name"
    t.boolean "isSpecial", default: false, null: false
    t.integer "special_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "admin", default: false, null: false
    t.boolean "subadmin", default: false, null: false
    t.integer "admin_level", default: 0, null: false
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "ca_limits", force: :cascade do |t|
    t.integer "ca_list_id"
    t.integer "admin_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "ca_lists", force: :cascade do |t|
    t.string "controller_name", default: "", null: false
    t.string "action_name", default: "", null: false
    t.string "path_name", default: "", null: false
    t.boolean "is_only_subadmin", default: false, null: false
    t.boolean "is_only_admin", default: false, null: false
    t.boolean "is_only_level", default: false, null: false
    t.integer "minimum_level", default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "command_chats", force: :cascade do |t|
    t.string "user_id"
    t.text "message"
    t.boolean "is_from_user"
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "group_admins", force: :cascade do |t|
    t.integer "group_id"
    t.integer "admin_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prefectures", force: :cascade do |t|
    t.string "regionId"
    t.string "objectId"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "objectId"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string "class_name"
    t.string "object_id"
    t.string "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "support_chats", force: :cascade do |t|
    t.string "user_id"
    t.text "message"
    t.boolean "is_from_user"
    t.boolean "is_read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id"
    t.string "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "parameter_id", default: "", null: false
    t.string "domain", default: "", null: false
    t.datetime "last_sent_time", default: "2021-09-10 03:31:00", null: false
    t.integer "unread_count", default: 0, null: false
  end

end
