require 'rails_helper'

RSpec.describe Workshop, type: :model do

  describe "validation" do
    it { should validate_presence_of(:continent) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:city) }
  end

  describe "#organiser" do
    let!(:workshop) { Workshop.create }
    let!(:organiser) { create_user(organiser: true, workshop: workshop) }

    it "provides the organiser" do
      expect(workshop.organiser).to eql(organiser)
    end

    it "ignores unlreated organisers" do
      other_organiser = create_user(organiser: true, email: 'other_organiser@example.com')
      expect(workshop.organiser).to eql(organiser)
    end

    it "ignores different kinds of team members" do
      facilitator = create_user(facilitator: true, email: 'facilitator@example.com')
      mentor = create_user(mentor: true, email: 'mentor@example.com')
      expect(workshop.organiser).to eql(organiser)
    end
  end

  describe "#facilitator" do
    let!(:workshop) { Workshop.create }
    let!(:facilitator) { create_user(facilitator: true, workshop: workshop) }

    it "provides the facilitator" do
      expect(workshop.facilitator).to eql(facilitator)
    end

    it "ignores unlreated facilitators" do
      other_facilitator = create_user(facilitator: true, email: 'other_facilitator@example.com')
      expect(workshop.facilitator).to eql(facilitator)
    end

    it "ignores different kinds of team members" do
      organiser = create_user(organiser: true, email: 'organiser@example.com')
      mentor = create_user(mentor: true, email: 'mentor@example.com')
      expect(workshop.facilitator).to eql(facilitator)
    end
  end

  describe "#percentage_complete" do
    context "one mandetory field complete" do
      let(:workshop) { Workshop.new }
      let(:single_mandetory_field_complete_percentage) { 8 }

      it "has continent" do
        workshop.continent = "Asia"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has country" do
        workshop.country = "UK"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has city" do
        workshop.city = "Edinburgh"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has venue_address" do
        workshop.venue_address = "Top of Royal Mile"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has google_maps_url" do
        workshop.google_maps_url = "http://google.com"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has start_time" do
        workshop.start_time = Time.now
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has end_time" do
        workshop.end_time = Time.now
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has time_zone" do
        workshop.time_zone = "BST"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has ticketing_url" do
        workshop.ticketing_url = "http://example.com"
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has organiser" do
        create_organiser(workshop)
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has facilitator" do
        facilitator = create_facilitator(workshop)
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end

      it "has mentors" do
        mentor = create_mentor(workshop)
        expect(workshop.percentage_complete).to eql(single_mandetory_field_complete_percentage)
      end
    end

    context "two mandetory fields complete" do
      let(:workshop) { Workshop.new }

      it "has two fields complete" do
        workshop.continent = "Asia"
        workshop.venue_address = "Top of Royal Mile"
        expect(workshop.percentage_complete).to eql(17)
      end
    end

    context "three mandetory fields complete" do
      let(:workshop) { Workshop.new }

      it "has three fields complete" do
        workshop.continent = "Asia"
        workshop.city = "Edinburgh"
        workshop.start_time = Time.now
        expect(workshop.percentage_complete).to eql(25)
      end
    end

    context "four mandetory fields complete" do
      let(:workshop) { Workshop.new }

      it "has four fields complete" do
        workshop.country = "UK"
        workshop.city = "Edinburgh"
        workshop.start_time = Time.now
        workshop.end_time = Time.now
        expect(workshop.percentage_complete).to eql(33)
      end
    end

    context "ten mandetory fields complete" do
      let(:workshop) { create_workshop }

      it "has 11 fields complete" do
        create_organiser(workshop)

        expect(workshop.percentage_complete).to eql(83)
      end
    end

    context "eleven mandetory fields complete" do
      let(:workshop) { create_workshop }

      it "has 11 fields complete" do
        create_organiser(workshop)
        create_facilitator(workshop)

        expect(workshop.percentage_complete).to eql(92)
      end
    end

    context "all mandetory fields complete" do
      let(:workshop) { create_workshop }

      it "has 12 fields complete" do
        create_organiser(workshop)
        create_facilitator(workshop)
        create_mentor(workshop)

        expect(workshop.percentage_complete).to eql(100)
      end
    end


    context "#pending" do
      let!(:workshop) do
        Workshop.create continent: "Europe",
          country: "United Kingdom",
          city: "Glasgow",
          venue_address: "City Centre",
          google_maps_url: "http://google.com",
          start_time: Time.now,
          end_time: Time.now,
          time_zone: 'GMT',
          ticketing_url: "http://google.com"
      end
      let!(:organiser) { create_organiser(workshop) }
      let!(:facilitator) { create_facilitator(workshop) }
      let!(:mentor) { create_mentor(workshop) }


      it "has all the correct parts" do
        expect(workshop.percentage_complete).to eql(100)
      end
    end
  end

  describe "#status" do
    let!(:workshop) { create_workshop }
    let!(:organiser) { create_organiser(workshop) }
    let!(:facilitator) { create_facilitator(workshop) }
    let!(:mentor) { create_mentor(workshop) }

    context "#draft" do
      [
        "continent",
        "country",
        "city",
        "venue_address",
        "google_maps_url",
        "start_time",
        "end_time",
        "time_zone",
        "ticketing_url"
      ].each do |attr|
        it "has no #{attr}" do
          workshop.update attr => nil
          expect(workshop.status).to eql("draft")
        end
      end

      it "has no organiser" do
        organiser.delete
        expect(workshop.status).to eql("draft")
      end

      it "has no facilitator" do
        facilitator.delete
        expect(workshop.status).to eql("draft")
      end

      it "has no mentors" do
        mentor.delete
        expect(workshop.status).to eql("draft")
      end
    end

    context "#pending" do
      it "has all the correct parts" do
        expect(workshop.status).to eql("pending")
      end
    end
  end

  describe "workshopsgrouped by country, sorted by city" do
    context "when no workshops exist" do
      it "has no workshops" do
        expect(Workshop.workshops_grouped_for_homepage).to be_empty
      end
    end

    context "has a number of workshops in the same city" do
      it "sorts workshops by city name" do
        aberdeen = create_workshop country: "United Kingdom", city: "Aberdeen"
        glasgow = create_workshop country: "United Kingdom", city: "Glasgow"
        edinburgh = create_workshop country: "United Kingdom", city: "Edinburgh"

        workshops = Workshop.all.workshops_grouped_for_homepage["Europe"]["United Kingdom"]
        expect(workshops.length).to eql(3)
        expect(workshops[0]).to eql(aberdeen)
        expect(workshops[1]).to eql(edinburgh)
        expect(workshops[2]).to eql(glasgow)
      end
    end

    context "groups cities by country" do
      it "sorts workshops by city name" do
        new_york = create_workshop country: "United States", city: "New York"
        glasgow = create_workshop country: "United Kingdom", city: "Glasgow"
        boston = create_workshop country: "United States", city: "Boston"

        expect(Workshop.all.group_by(&:country).length).to eql(2)
        uk = Workshop.all.group_by(&:country)["United Kingdom"]
        usa = Workshop.all.group_by(&:country)["United States"]

        expect(uk).to eql([glasgow])
        expect(usa).to eql([new_york, boston])
      end
    end

    context "sorts cities grouped by country" do
      it "sorts workshops by city name" do
        new_york = create_workshop country: "United States", city: "New York"
        glasgow = create_workshop country: "United Kingdom", city: "Glasgow"
        boston = create_workshop country: "United States", city: "Boston"

        result = Workshop.all.order(:city).group_by(&:country)

        expect(result.length).to eql(2)
        uk = result["United Kingdom"]
        usa = result["United States"]

        expect(uk).to eql([glasgow])
        expect(usa).to eql([boston, new_york])
      end
    end

    context "countries cities grouped by country and continent" do
      it "sorts workshops by city name" do
        new_york = create_workshop continent: "North America", country: "United States", city: "New York"
        glasgow = create_workshop continent: "Europe", country: "United Kingdom", city: "Glasgow"
        amsterdam = create_workshop continent: "Europe", country: "Holland", city: "Amsterdam"
        boston = create_workshop continent: "North America", country: "United States", city: "Boston"
        toronto = create_workshop continent: "North America", country: "Canada", city: "Toronto"

        result = Workshop.workshops_grouped_for_homepage

        expect(result.length).to eql(2)
        europe = result["Europe"]
        north_america = result["North America"]

        expect(europe.length).to eql(2)
        expect(europe["Holland"]).to eql([amsterdam])
        expect(europe["United Kingdom"]).to eql([glasgow])

        expect(north_america.length).to eql(2)
        expect(north_america["Canada"]).to eql([toronto])
        expect(north_america["United States"]).to eql([boston, new_york])
      end
    end


  end

  def create_organiser(workshop)
    create_user email: "organiser@example.com", organiser: true, workshop: workshop
  end

  def create_facilitator(workshop)
    create_user email: "facilitator@example.com", facilitator: true, workshop: workshop
  end

  def create_mentor(workshop)
    create_user email: "mentor@example.com", mentor: true, workshop: workshop
  end

  def create_user(attrs)
    default_attrs = {email: 'user@example.com', full_name: 'The user', biography: "Hello", picture_url: "http://google.com", run_workshop_explaination: "❤️", password: "password", password_confirmation: "password"}

    result = User.new(default_attrs.merge(attrs))
    result.skip_confirmation!
    result.save!

    result
  end

  def create_workshop(workshop_attributes = {})
    attributes = {continent: "Europe", country: "United Kingdom", city: "Glasgow" }.merge(workshop_attributes)
    Workshop.create continent: attributes[:continent],
      country: attributes[:country],
      city: attributes[:city],
      venue_address: "City Centre",
      google_maps_url: "http://google.com",
      start_time: Time.now,
      end_time: Time.now,
      time_zone: 'GMT',
      ticketing_url: "http://google.com"
  end
end

