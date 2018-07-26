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

ActiveRecord::Schema.define(version: 2018_07_26_063246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pets", force: :cascade do |t|
    t.bigint "pet_id"
    t.bigint "api_id"
    t.float "adoption_cost"
    t.text "description"
    t.date "date_of_birth"
    t.text "breed_primary"
    t.text "breed_secondary"
    t.boolean "desexed"
    t.string "primary_colour"
    t.string "secondary_colour"
    t.text "name"
    t.boolean "behaviour_evaluated"
    t.boolean "health_checked"
    t.boolean "vaccinated"
    t.boolean "wormed"
    t.boolean "special_needs_ok"
    t.boolean "long_term_resident"
    t.boolean "senior"
    t.boolean "microchipped"
    t.bigint "shelter"
    t.string "sex"
    t.string "size"
    t.string "state"
    t.string "animal_status"
    t.bigint "animal_type"
    t.text "public_url"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type_name"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "pet_id"
    t.bigint "animal_id"
    t.bigint "api_id"
    t.text "image_path"
    t.text "api_path"
    t.boolean "isDefault"
    t.boolean "isActive"
    t.boolean "isDownloaded"
  end

  create_table "shelters", force: :cascade do |t|
    t.bigint "shelter_id"
    t.string "name"
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "phone"
    t.text "details"
  end

  create_table "sites", force: :cascade do |t|
    t.text "url"
    t.datetime "last_scan", default: "2018-07-18 04:04:18"
    t.datetime "next_scan", default: "2018-07-18 04:04:18"
    t.integer "scan_interval", default: 1440
    t.datetime "last_scraped"
    t.index ["last_scan"], name: "index_sites_on_last_scan"
    t.index ["next_scan"], name: "index_sites_on_next_scan"
    t.index ["url"], name: "index_sites_on_url", unique: true
  end

end
