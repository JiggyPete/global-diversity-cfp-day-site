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

ActiveRecord::Schema.define(version: 20171111111117) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "full_name"
    t.text "biography"
    t.text "picture_url"
    t.text "run_workshop_explaination"
    t.integer "workshop_id"
    t.boolean "admin"
    t.boolean "organiser"
    t.boolean "facilitator"
    t.boolean "mentor"
    t.string "preferred_contact_method"
    t.string "preferred_contact_value"
    t.string "displayed_email"
    t.string "displayed_twitter"
    t.string "displayed_github"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workshops", force: :cascade do |t|
    t.string "continent"
    t.string "country"
    t.string "city"
    t.text "venue_address"
    t.string "google_maps_url"
    t.time "start_time"
    t.time "end_time"
    t.string "time_zone"
    t.string "ticketing_url"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false
    t.boolean "access_information_prodivded", default: false
    t.boolean "public_transport_near_venue", default: false
    t.text "public_transport_near_venue_notes", default: ""
    t.boolean "public_transport_accessible_mobility_devices", default: false
    t.text "public_transport_accessible_mobility_devices_notes", default: ""
    t.boolean "public_transport_accessible_service_animals", default: false
    t.text "public_transport_accessible_service_animals_notes", default: ""
    t.boolean "public_transport_accessible_sight_impaired", default: false
    t.text "public_transport_accessible_sight_impaired_notes", default: ""
    t.boolean "area_around_venue_safe", default: false
    t.text "area_around_venue_safe_notes", default: ""
    t.string "how_far_parking", default: ""
    t.string "cost_of_parking", default: ""
    t.boolean "parking_well_lit", default: false
    t.text "parking_well_lit_notes", default: ""
    t.boolean "parking_gated", default: false
    t.text "parking_gated_notes", default: ""
    t.boolean "parking_gaurded", default: false
    t.text "parking_gaurded_notes", default: ""
    t.boolean "venue_security", default: false
    t.text "venue_security_notes", default: ""
    t.text "venue_access_process", default: ""
    t.text "steps", default: ""
    t.text "ramps_or_elevators", default: ""
    t.text "elevators_buttons", default: ""
    t.text "childcare_nearby", default: ""
    t.boolean "quiet_room", default: false
    t.text "quiet_room_notes", default: ""
    t.boolean "nursing_room_for_new_mothers", default: false
    t.text "nursing_room_for_new_mothers_notes", default: ""
    t.boolean "safe_for_small_children", default: false
    t.text "safe_for_small_children_notes", default: ""
    t.boolean "navigable_by_disabled", default: false
    t.text "navigable_by_disabled_notes", default: ""
    t.boolean "chairs_arms", default: false
    t.text "chairs_arms_notes", default: ""
    t.integer "number_of_bathrooms", default: 0
    t.integer "number_of_handicap_stalls", default: 0
    t.integer "number_of_gender_neutral_stalls", default: 0
    t.boolean "drinks_allowed", default: false
    t.text "drinks_allowed_notes", default: ""
  end

end
