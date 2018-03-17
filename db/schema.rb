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

ActiveRecord::Schema.define(version: 20180317051741) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attempts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "drill_group_id"
    t.float "score"
    t.integer "current_question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_question_id"], name: "index_attempts_on_current_question_id"
    t.index ["drill_group_id"], name: "index_attempts_on_drill_group_id"
    t.index ["user_id"], name: "index_attempts_on_user_id"
  end

  create_table "drill_groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "points"
    t.string "level"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_drill_groups_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "description"
    t.bigint "drill_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["drill_group_id"], name: "index_questions_on_drill_group_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.text "answer"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_solutions_on_question_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "attempts", "drill_groups"
  add_foreign_key "attempts", "questions", column: "current_question_id"
  add_foreign_key "attempts", "users"
  add_foreign_key "drill_groups", "users"
  add_foreign_key "questions", "drill_groups"
  add_foreign_key "solutions", "questions"
end
