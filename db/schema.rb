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

ActiveRecord::Schema[7.0].define(version: 2026_05_21_095503) do
  create_table "audit_logs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "action", null: false
    t.string "target_type"
    t.integer "target_id"
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action"], name: "index_audit_logs_on_action"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "hotpepper_id"
    t.string "name"
    t.string "address"
    t.string "genre"
    t.string "area"
    t.string "budget"
    t.string "photo_url"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotpepper_id"], name: "index_restaurants_on_hotpepper_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "restaurant_id", null: false
    t.date "visited_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_visits_on_restaurant_id"
    t.index ["user_id", "restaurant_id"], name: "index_visits_on_user_id_and_restaurant_id", unique: true
    t.index ["user_id"], name: "index_visits_on_user_id"
  end

  add_foreign_key "audit_logs", "users"
  add_foreign_key "visits", "restaurants"
  add_foreign_key "visits", "users"
end
