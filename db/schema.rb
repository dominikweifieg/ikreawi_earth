# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111109105809) do

  create_table "answers", :force => true do |t|
    t.text     "body"
    t.boolean  "correct"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "short_title"
    t.text     "description"
    t.string   "identifier"
    t.integer  "old_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "original_pruefung", :default => false
    t.string   "app_name",          :default => "iKreawi"
    t.integer  "type_id",           :default => 0
  end

  create_table "questions", :force => true do |t|
    t.text     "body"
    t.text     "comment"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trainer_licenses", :force => true do |t|
    t.string   "license"
    t.string   "email"
    t.string   "computer_name"
    t.boolean  "rejected",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                :null => false
    t.string   "email",                                :null => false
    t.string   "crypted_password",                     :null => false
    t.string   "password_salt",                        :null => false
    t.string   "persistence_token",                    :null => false
    t.integer  "login_count",       :default => 0,     :null => false
    t.datetime "last_login_at"
    t.boolean  "enabled",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
