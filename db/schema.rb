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

ActiveRecord::Schema[7.0].define(version: 2023_06_16_215025) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "discount_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_discount_codes_on_code", unique: true
  end

  create_table "ingredients", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "item_ingredients", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "ingredient_id", null: false
    t.string "ingredient_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id", "item_id"], name: "index_item_ingredients_on_ingredient_id_and_item_id", unique: true
    t.index ["ingredient_id"], name: "index_item_ingredients_on_ingredient_id"
    t.index ["item_id"], name: "index_item_ingredients_on_item_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.index ["order_id"], name: "index_items_on_order_id"
  end

  create_table "order_promotion_codes", id: false, force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "promotion_code_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "promotion_code_id"], name: "index_order_promotion_codes_on_order_id_and_promotion_code_id", unique: true
    t.index ["order_id"], name: "index_order_promotion_codes_on_order_id"
    t.index ["promotion_code_id"], name: "index_order_promotion_codes_on_promotion_code_id"
  end

  create_table "orders", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "status", default: "open"
    t.bigint "discount_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_code_id"], name: "index_orders_on_discount_code_id"
    t.index ["uuid"], name: "index_orders_on_uuid", unique: true
  end

  create_table "promotion_codes", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_promotion_codes_on_code", unique: true
  end

  add_foreign_key "item_ingredients", "ingredients"
  add_foreign_key "item_ingredients", "items"
  add_foreign_key "items", "orders"
  add_foreign_key "order_promotion_codes", "orders"
  add_foreign_key "order_promotion_codes", "promotion_codes"
  add_foreign_key "orders", "discount_codes"
end
