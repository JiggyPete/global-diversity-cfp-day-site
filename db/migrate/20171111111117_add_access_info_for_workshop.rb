class AddAccessInfoForWorkshop < ActiveRecord::Migration[5.1]
  def change
    add_column :workshops, :access_information_prodivded, :boolean, default: false

    # Getting to and from the venue

    add_column :workshops, :public_transport_near_venue, :boolean, default: false
    add_column :workshops, :public_transport_near_venue_notes, :text, default: ""

    add_column :workshops, :public_transport_accessible_mobility_devices, :boolean, default: false
    add_column :workshops, :public_transport_accessible_mobility_devices_notes, :text, default: ""

    add_column :workshops, :public_transport_accessible_service_animals, :boolean, default: false
    add_column :workshops, :public_transport_accessible_service_animals_notes, :text, default: ""

    add_column :workshops, :public_transport_accessible_sight_impaired, :boolean, default: false
    add_column :workshops, :public_transport_accessible_sight_impaired_notes, :text, default: ""

    add_column :workshops, :area_around_venue_safe, :boolean, default: false
    add_column :workshops, :area_around_venue_safe_notes, :text, default: ""

    add_column :workshops, :how_far_parking, :string, default: ""
    add_column :workshops, :cost_of_parking, :string, default: ""

    add_column :workshops, :parking_well_lit, :boolean, default: false
    add_column :workshops, :parking_well_lit_notes, :text, default: ""

    add_column :workshops, :parking_gated, :boolean, default: false
    add_column :workshops, :parking_gated_notes, :text, default: ""

    add_column :workshops, :parking_gaurded, :boolean, default: false
    add_column :workshops, :parking_gaurded_notes, :text, default: ""

    # Accessing the venue

    add_column :workshops, :venue_security, :boolean, default: false
    add_column :workshops, :venue_security_notes, :text, default: ""

    add_column :workshops, :venue_access_process, :text, default: ""
    add_column :workshops, :steps, :text, default: ""
    add_column :workshops, :ramps_or_elevators, :text, default: ""
    add_column :workshops, :elevators_buttons, :text, default: ""
    add_column :workshops, :childcare_nearby, :text, default: ""

    # Venue

    add_column :workshops, :quiet_room, :boolean, default: false
    add_column :workshops, :quiet_room_notes, :text, default: ""

    add_column :workshops, :nursing_room_for_new_mothers, :boolean, default: false
    add_column :workshops, :nursing_room_for_new_mothers_notes, :text, default: ""

    add_column :workshops, :safe_for_small_children, :boolean, default: false
    add_column :workshops, :safe_for_small_children_notes, :text, default: ""

    add_column :workshops, :navigable_by_disabled, :boolean, default: false
    add_column :workshops, :navigable_by_disabled_notes, :text, default: ""

    add_column :workshops, :chairs_arms, :boolean, default: false
    add_column :workshops, :chairs_arms_notes, :text, default: ""

    add_column :workshops, :number_of_bathrooms, :integer, default: 0
    add_column :workshops, :number_of_handicap_stalls, :integer, default: 0
    add_column :workshops, :number_of_gender_neutral_stalls, :integer, default: 0

    add_column :workshops, :drinks_allowed, :boolean, default: false
    add_column :workshops, :drinks_allowed_notes, :text, default: ""
  end
end
