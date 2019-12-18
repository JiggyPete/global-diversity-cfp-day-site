require 'rails_helper'

RSpec.describe Workshop, type: :model do

  describe "validation" do
    it { should validate_presence_of(:continent) }
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:city) }

    describe "city" do
      context "one workshop per city per year" do
        it "is valid with more than one workshop per city when years are different" do
          first = create_workshop(city: "Edinburgh", year: 2018)
          second = create_workshop(city: "Edinburgh", year: 2019)
          third = create_workshop(city: "Edinburgh", year: nil)

          expect(Workshop.unscoped.count).to eql(3)
        end

        it "invalid to have more than one workshop per city per year" do
          first = create_workshop(city: "Edinburgh", year: nil)
          second = create_workshop(city: "Edinburgh", year: nil)

          expect(first).to be_valid
          expect(second).not_to be_valid
        end
      end
    end
  end

  describe "default scope" do
    it "provides workshops with no :year set" do
      no_year  = create_workshop year: nil
      year_2019  = create_workshop year: 2019

      expect(Workshop.all).not_to include(year_2019)
      expect(Workshop.unscoped.all).to include(year_2019)

      expect(Workshop.all).to include(no_year)
    end
  end

  describe "#previous_workshop_for" do
    it "provides the 2019 workshop, when one exists for user" do
      original_workshop = create_workshop year: 2019
      user = create_user(organiser: true, workshop: original_workshop)

      expect(Workshop.previous_workshop_for user).to eql(original_workshop)
    end

    it "provides nil, when a new workshop exists" do
      original_workshop = create_workshop year: nil
      user = create_user(organiser: true, workshop: original_workshop)

      expect(Workshop.previous_workshop_for user).to be_nil
    end

    it "provides nil, when no workshop exists" do
      user = create_user
      expect(Workshop.previous_workshop_for user).to be_nil
    end
  end

  describe "#duplicate_for_2020" do
    let(:original_workshop) { create_workshop year: 2019 }
    let!(:organiser) { create_user(organiser: true, workshop: original_workshop) }
    let!(:facilitator) { create_user(facilitator: true, workshop: original_workshop) }
    let!(:mentor_1) { create_user(mentor: true, workshop: original_workshop) }
    let!(:mentor_2) { create_user(mentor: true, workshop: original_workshop) }
    let!(:mentor_3) { create_user(mentor: true, workshop: original_workshop) }

    it "creates and returns a duplicate workshop" do
      new_workshop = original_workshop.duplicate_for_2020(organiser)

      expect(new_workshop.id).not_to eql(original_workshop.id)
      expect(new_workshop.year).to be_nil
    end

    it "handle previous organiser being nil" do
      organiser.destroy
      new_workshop = original_workshop.duplicate_for_2020(organiser)
      expect(new_workshop.organiser).to be_nil
    end

    it "previous organiser is migrated to new workshop" do
      new_workshop = original_workshop.duplicate_for_2020(organiser)

      organiser.reload
      expect(organiser.workshop).to eql(new_workshop)

      new_workshop.reload
      expect(new_workshop.organiser).to eql(organiser)

      reloaded_original_workshop = Workshop.unscoped.find(original_workshop.id)
      expect(reloaded_original_workshop.organiser).to be_nil
    end

    it "handle previous facilitator being nil" do
      facilitator.destroy
      new_workshop = original_workshop.duplicate_for_2020(organiser)
      expect(new_workshop.facilitators).to be_empty
    end

    it "previous facilitator is migrated to new workshop" do
      new_workshop = original_workshop.duplicate_for_2020(organiser)

      facilitator.reload
      expect(facilitator.workshop).to eql(new_workshop)

      new_workshop.reload
      expect(new_workshop.facilitators).to include(facilitator)

      reloaded_original_workshop = Workshop.unscoped.find(original_workshop.id)
      expect(reloaded_original_workshop.facilitators).to be_empty
    end

    it "handle previous workshop with no mentors" do
      mentor_1.destroy
      mentor_2.destroy
      mentor_3.destroy

      new_workshop = original_workshop.duplicate_for_2020(organiser)
      expect(new_workshop.mentors).to be_empty
    end

    it "previous mentors are migrated to new workshop" do
      new_workshop = original_workshop.duplicate_for_2020(organiser)

      [mentor_1, mentor_2, mentor_3].each do |mentor|
        mentor.reload
        expect(mentor.workshop).to eql(new_workshop)
      end

      new_workshop.reload
      expect(new_workshop.mentors).to include(mentor_1, mentor_2, mentor_3)

      reloaded_original_workshop = Workshop.unscoped.find(original_workshop.id)
      expect(reloaded_original_workshop.mentors).to be_empty
    end

    it "does not duplicate previous ticketing_url" do
      expect(original_workshop.ticketing_url).not_to be_nil
      new_workshop = original_workshop.duplicate_for_2020(organiser)
      expect(new_workshop.ticketing_url).to be_nil
    end

    context "when the duplicating user was last years facilitator" do
      it "makes the original facilitator the organiser" do
        new_workshop = original_workshop.duplicate_for_2020(facilitator)
        facilitator.reload
        expect(new_workshop.organisers).to include(facilitator)
      end
    end

    context "when the duplicating user was last years mentor" do
      it "makes the original mentor the organiser" do
        new_workshop = original_workshop.duplicate_for_2020(mentor_1)
        mentor_1.reload
        expect(new_workshop.organisers).to include(mentor_1)
      end
    end
  end

  describe "#organiser" do
    let(:workshop) { Workshop.create }
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

  describe "#facilitators" do
    let!(:workshop) { create_workshop(city: "Edinburgh", year: nil) }
    let!(:facilitator) { create_user(facilitator: true, workshop: workshop) }

    it "provides the facilitator" do
      expect(workshop.facilitators).to include(facilitator)
    end

    it "ignores unlreated facilitators" do
      other_facilitator = create_user(facilitator: true, email: 'other_facilitator@example.com')
      expect(workshop.facilitators).not_to include(other_facilitator)
    end

    it "ignores different kinds of team members" do
      organiser = create_user(organiser: true, email: 'organiser@example.com')
      mentor = create_user(mentor: true, email: 'mentor@example.com')
      expect(workshop.facilitators).to include(facilitator)
      expect(workshop.facilitators.length).to eql(1)
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

  describe "workshops grouped by country, sorted by city" do
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
        expect(usa[0]).to eql(new_york)
        expect(usa[1]).to eql(boston)
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
  describe "newest_workshops_by_continent groups by country, sorted by city" do
    context "when no workshops exist" do
      it "has no workshops" do
        expect(Workshop.newest_workshops_by_continent).to be_empty
      end
    end

    context "has a number of workshops in the same city" do
      it "sorts workshops by city name" do
        aberdeen = create_workshop country: "United Kingdom", city: "Aberdeen"
        glasgow = create_workshop country: "United Kingdom", city: "Glasgow"
        edinburgh = create_workshop country: "United Kingdom", city: "Edinburgh"

        workshops = Workshop.newest_workshops_by_continent["Europe"]["United Kingdom"]
        expect(workshops.length).to eql(3)
        expect(workshops).to eql([aberdeen, edinburgh, glasgow])
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

        result = Workshop.newest_workshops_by_continent

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

    it "only returns the most recent 5 workshops" do
      new_york = create_workshop continent: "North America", country: "United States", city: "New York", created_at: 1.day.ago
      seattle = create_workshop continent: "North America", country: "United States", city: "Seattle", created_at: 2.days.ago
      atlanta = create_workshop continent: "North America", country: "United States", city: "Atlanta", created_at: 3.days.ago
      los_angeles = create_workshop continent: "North America", country: "United States", city: "Los Angeles", created_at: 4.days.ago
      portland = create_workshop continent: "North America", country: "United States", city: "Portland", created_at: 5.days.ago

      old_city = create_workshop continent: "North America", country: "United States", city: "Memphis", created_at: 1.week.ago
      old_country = create_workshop continent: "North America", country: "Canada", city: "Toronto", created_at: 2.weeks.ago
      old_continent = create_workshop continent: "Europe", country: "Holland", city: "Amsterdam", created_at: 3.weeks.ago

      result = Workshop.newest_workshops_by_continent

      expect(result["Europe"]).to be_nil

      north_america = result["North America"]
      expect(north_america["Canada"]).to be_nil
      expect(north_america["United States"]).to eql([
        atlanta, los_angeles, new_york, portland, seattle
      ])
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

  def create_user(attrs={})
    default_attrs = {email: "user#{rand(99999)}@example.com", full_name: 'The user', biography: "Hello", picture_url: "http://google.com", run_workshop_explaination: "❤️", password: "password", password_confirmation: "password"}

    result = User.new(default_attrs.merge(attrs))
    result.skip_confirmation!
    result.save!

    result
  end

  def create_workshop(workshop_attributes = {})
    default_attributes = {
      continent: "Europe",
      country: "United Kingdom",
      city: "Glasgow#{rand(999)}" ,
      venue_address: "City Centre",
      google_maps_url: "http://google.com",
      start_time: Time.now,
      end_time: Time.now,
      ticketing_url: "http://google.com"
    }

    attributes = default_attributes.merge(workshop_attributes)
    Workshop.create attributes
  end
end

