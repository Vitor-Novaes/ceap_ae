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

ActiveRecord::Schema.define(version: 2021_09_25_222556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deputies", force: :cascade do |t|
    t.string "cpf", null: false
    t.bigint "ide", null: false
    t.bigint "parlamentary_card", null: false
    t.string "name", null: false
    t.string "state", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_deputies_on_organization_id"
  end

  create_table "expenditures", force: :cascade do |t|
    t.text "description", null: false
    t.text "especification"
    t.string "provider", null: false
    t.string "provider_documentation", null: false
    t.datetime "date"
    t.integer "period", null: false
    t.float "net_value"
    t.string "receipt_type"
    t.string "receipt_url"
    t.bigint "deputy_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deputy_id"], name: "index_expenditures_on_deputy_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "abbreviation"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "deputies", "organizations"
  add_foreign_key "expenditures", "deputies"
end
