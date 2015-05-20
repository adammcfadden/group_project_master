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

ActiveRecord::Schema.define(version: 20150520180927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "battles", force: :cascade do |t|
    t.string  "name"
    t.boolean "boss?"
    t.boolean "active?"
  end

  create_table "entities", force: :cascade do |t|
    t.string  "name"
    t.integer "level"
    t.integer "health"
    t.integer "location_x"
    t.integer "location_y"
    t.boolean "pc?"
    t.boolean "alive?"
    t.integer "xp"
    t.integer "battle_id"
    t.integer "str"
    t.string  "image_path"
    t.boolean "entity_drawn?"
  end

  create_table "entities_weapons", id: false, force: :cascade do |t|
    t.integer "entity_id"
    t.integer "weapon_id"
  end

  add_index "entities_weapons", ["entity_id"], name: "index_entities_weapons_on_entity_id", using: :btree
  add_index "entities_weapons", ["weapon_id"], name: "index_entities_weapons_on_weapon_id", using: :btree

  create_table "weapons", force: :cascade do |t|
    t.string  "name"
    t.string  "type"
    t.integer "max_power"
    t.integer "min_power"
    t.boolean "isequipped?"
  end

end
