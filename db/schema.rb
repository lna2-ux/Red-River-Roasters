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

ActiveRecord::Schema[7.2].define(version: 2026_11_24_221341) do
  create_table "accounts", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "street_address"
    t.string "city"
    t.string "postal_code"
    t.integer "province_id", null: false
    t.index ["email"], name: "index_accounts_on_email", unique: true
    t.index ["province_id"], name: "index_accounts_on_province_id"
    t.index ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "categorizations", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_categorizations_on_category_id"
    t.index ["product_id"], name: "index_categorizations_on_product_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "street_address"
    t.string "city"
    t.string "postal_code"
    t.integer "province_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email"
    t.index ["province_id"], name: "index_customers_on_province_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.string "product_name", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "line_total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "province_id"
    t.decimal "subtotal", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "gst_rate", precision: 6, scale: 4, default: "0.0", null: false
    t.decimal "pst_rate", precision: 6, scale: 4, default: "0.0", null: false
    t.decimal "hst_rate", precision: 6, scale: 4, default: "0.0", null: false
    t.decimal "gst_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "pst_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "hst_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "status", default: "placed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_payment_id"
    t.datetime "paid_at"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["province_id"], name: "index_orders_on_province_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "sku", null: false
    t.text "description", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock_quantity", default: 0, null: false
    t.boolean "is_active", default: true, null: false
    t.boolean "on_sale", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_products_on_sku", unique: true
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation", null: false
    t.decimal "gst_rate", precision: 5, scale: 4, default: "0.0", null: false
    t.decimal "pst_rate", precision: 5, scale: 4, default: "0.0", null: false
    t.decimal "hst_rate", precision: 5, scale: 4, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abbreviation"], name: "index_provinces_on_abbreviation", unique: true
    t.index ["name"], name: "index_provinces_on_name", unique: true
  end

  create_table "site_pages", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_site_pages_on_slug", unique: true
  end

  add_foreign_key "accounts", "provinces"
  add_foreign_key "categorizations", "categories"
  add_foreign_key "categorizations", "products"
  add_foreign_key "customers", "provinces"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "provinces"
end
