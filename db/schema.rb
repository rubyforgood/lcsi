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

ActiveRecord::Schema.define(version: 20170520150135) do

  create_table "administrators", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.string "original_filename"
    t.string "content_type"
    t.integer "attachable_id"
    t.string "attachable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachable_type", "attachable_id"], name: "index_attachments_on_attachable_type_and_attachable_id"
  end

  create_table "contests", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
  end

  create_table "problems", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "timeout"
    t.boolean "has_input"
    t.boolean "auto_judge"
    t.boolean "ignore_case"
    t.string "whitespace_rule", default: "plain diff"
    t.index ["contest_id"], name: "index_problems_on_contest_id"
  end

  create_table "submission_results", force: :cascade do |t|
    t.text "output"
    t.integer "submission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["submission_id"], name: "index_submission_results_on_submission_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer "team_id"
    t.integer "problem_id"
    t.integer "runtime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["problem_id"], name: "index_submissions_on_problem_id"
    t.index ["team_id"], name: "index_submissions_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password"
    t.integer "contest_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contest_id"], name: "index_teams_on_contest_id"
  end

end
