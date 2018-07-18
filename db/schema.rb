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

ActiveRecord::Schema.define(version: 2018_07_18_032227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pets", force: :cascade do |t|
    t.bigint "pet_id"
    t.bigint "api_id"
    t.bigint "shelterBuddyId"
    t.float "adoptionCost"
    t.text "description1"
    t.text "description2"
    t.date "date_of_birth"
    t.string "readable_age"
    t.integer "ageMonths"
    t.integer "ageYears"
    t.boolean "isCrossBreed"
    t.text "breedPrimary"
    t.text "breedSecondary"
    t.boolean "isDesexed"
    t.string "primary_colour"
    t.string "secondary_colour"
    t.text "colour_url"
    t.bigint "breeder_id"
    t.text "name"
    t.boolean "hadBehaviourEvaluated"
    t.boolean "hadHealthChecked"
    t.boolean "isVaccinated"
    t.boolean "isWormed"
    t.boolean "isSpecialNeedsOkay"
    t.boolean "isLongtermResident"
    t.boolean "isSeniorPet"
    t.boolean "isMicrochipped"
    t.bigint "shelter"
    t.string "sex"
    t.string "size"
    t.text "youTubeVideo"
    t.string "state"
    t.bigint "animal_status"
    t.bigint "animal_type"
    t.text "public_url"
    t.boolean "isActive"
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

  create_table "sites", force: :cascade do |t|
    t.text "url"
    t.datetime "last_scan", default: "2018-07-18 04:04:18"
    t.datetime "next_scan", default: "2018-07-18 04:04:18"
    t.integer "scan_interval", default: 1440
    t.index ["last_scan"], name: "index_sites_on_last_scan"
    t.index ["next_scan"], name: "index_sites_on_next_scan"
    t.index ["url"], name: "index_sites_on_url", unique: true
  end

end
