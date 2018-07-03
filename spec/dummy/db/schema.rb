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

ActiveRecord::Schema.define(version: 20180703192406) do

  create_table "promotions", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "prefixed_file_one_file_name"
    t.string   "prefixed_file_one_content_type"
    t.integer  "prefixed_file_one_file_size"
    t.datetime "prefixed_file_one_updated_at"
    t.string   "prefixed_file_two_file_name"
    t.string   "prefixed_file_two_content_type"
    t.integer  "prefixed_file_two_file_size"
    t.datetime "prefixed_file_two_updated_at"
    t.string   "prefixed_file_file_name"
    t.string   "prefixed_file_content_type"
    t.integer  "prefixed_file_file_size"
    t.datetime "prefixed_file_updated_at"
  end

  create_table "rails_pallet_uploads", force: :cascade do |t|
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

end
