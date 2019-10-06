require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "#workshop_landing_page_for" do
    context "admin user signs in" do
      it "supplies the admin workshops path" do
        admin = User.new(admin: true)
        expect(helper.workshop_landing_page_for(admin)).to eql(admin_users_path)
      end
    end

    context "signed up user with a 2020 workshop signs in" do
      it "supplies the path to the workshop :show" do
        workshop = Workshop.new(id: 700, year: nil)
        user = User.new(workshop: workshop)

        expect(helper.workshop_landing_page_for(user)).to eql(workshop_path(700))
      end
    end

    context "signed up user with only a 2019 workshop signs in" do
      it "supplies the path to the workshop :new_duplicate" do
        workshop = Workshop.create(id: 700, year: 2019, continent: "Asia", country: "Japan", city: "Tokyo" )
        user = User.new(workshop_id: 700)

        expect(helper.workshop_landing_page_for(user)).to eql(workshop_new_duplicate_path(700))
      end
    end

    context "signed up user with only a 2018 or previous workshop signs in" do
      it "supplies the new_workshop_path" do
        workshop = Workshop.create(id: 700, year: 2018, continent: "Asia", country: "Japan", city: "Tokyo" )
        user = User.new(workshop_id: 700)

        expect(helper.workshop_landing_page_for(user)).to eql(new_workshop_path)
      end
    end

    context "newly created user with no workshop signs in" do
      it "supplies the new_workshop_path" do
        user = User.new(workshop: nil)

        expect(helper.workshop_landing_page_for(user)).to eql(new_workshop_path)
      end
    end
  end
end
