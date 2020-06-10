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

ActiveRecord::Schema.define(version: 20200601183407) do

  create_table "billtos", force: :cascade do |t|
    t.string "billto_code"
    t.string "terms_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dart_sales_pricing_currents", force: :cascade do |t|
    t.integer "invoice_numb"
    t.string "sls_rep"
    t.string "AM_OF"
    t.integer "disregard_catch_wgt"
    t.string "AM_ST"
    t.string "owner"
    t.string "order_stat"
    t.string "cost_ctr"
    t.string "order_numb"
    t.string "rel_numb"
    t.string "item_no"
    t.string "cust_code"
    t.string "bus_name"
    t.string "sales_type"
    t.string "shipto_code"
    t.string "cust_group"
    t.string "cust_subgroup"
    t.string "met_of_ship"
    t.string "carr_code"
    t.string "route_code"
    t.string "rep1"
    t.date "order_date"
    t.date "dueout_date"
    t.date "sale_date"
    t.date "pk_prt_date"
    t.string "pick_numb"
    t.string "part_code"
    t.string "alt_part1"
    t.string "part_status"
    t.string "part_desc"
    t.string "part_grp"
    t.string "part_subgrp"
    t.float "catch_wt"
    t.integer "qty"
    t.integer "ship_qty"
    t.string "picker_id"
    t.string "shipadd1"
    t.string "shipcity"
    t.string "shipst"
    t.string "uom"
    t.float "item_wgt"
    t.string "item_sales_acct"
    t.float "item_list_price"
    t.float "item_price"
    t.float "item_ntprice"
    t.float "ext_price"
    t.integer "qty_sold"
    t.float "total_lbs"
    t.float "sales_dol"
    t.string "lot_invitem"
    t.string "lot_shipitem"
    t.string "day_of_month"
    t.string "day_name"
    t.string "week_of_year"
    t.string "month_name"
    t.string "year_val"
    t.float "stnd_matl_cost"
    t.float "gp_dol_xpl"
    t.float "tot_std_cost"
    t.float "gp_dol_lot"
    t.string "trailer_location"
    t.date "date_entered"
    t.time "time_entered"
    t.integer "qty_invitem"
    t.string "orig_order_numb"
    t.string "orig_rel_numb"
    t.string "invc_type"
    t.string "item_priceid"
    t.float "numfld2"
    t.string "price_id"
    t.float "part_price"
    t.string "part_uom"
    t.date "eff_date"
    t.date "end_date"
    t.float "uom_conv"
    t.float "alt_list_price"
    t.string "Price_Sheet_Type"
    t.string "team"
    t.string "channel"
    t.string "price_id_04"
    t.float "part_price_04"
    t.string "part_uom_04"
    t.date "eff_date_04"
    t.date "end_date_04"
    t.float "alt_list_price_04"
    t.float "base"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "Fiscal_Year"
    t.string "Fiscal_Month"
  end

  create_table "geocodes", force: :cascade do |t|
    t.string "state_name"
    t.string "city_name"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orderfroms", force: :cascade do |t|
    t.string "bus_name"
    t.string "acct_manager"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cust_code"
    t.string "zip"
    t.string "ship_to"
  end

  create_table "prospect_calls", force: :cascade do |t|
    t.integer "prospect_id"
    t.string "who"
    t.string "outcome"
    t.date "call_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "method"
    t.string "subject"
  end

  create_table "prospects", force: :cascade do |t|
    t.string "customer_id"
    t.string "name"
    t.string "credit_terms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rep"
    t.string "prev_rep"
    t.date "rep_date"
    t.boolean "status"
    t.string "source"
    t.string "zip"
    t.date "active_date"
    t.boolean "customer"
    t.string "city"
    t.string "state"
    t.string "ship_to"
    t.boolean "compass"
    t.boolean "new_opening"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manager"
    t.string "manager_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
