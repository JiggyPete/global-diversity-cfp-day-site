require 'rails_helper'

RSpec.describe Workshop, type: :model do

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


  describe "#status" do
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
    let!(:organiser) { create_user email: "organiser@example.com", organiser: true, workshop: workshop }
    let!(:facilitator) { create_user email: "facilitator@example.com", facilitator: true, workshop: workshop }
    let!(:mentor) { create_user email: "mentor@example.com", mentor: true, workshop: workshop }

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

    context "#awaiting_approval" do
      it "has all the correct parts" do
        expect(workshop.status).to eql("awaiting_approval")
      end
    end
  end

  def create_user(attrs)
    default_attrs = {email: 'user@example.com', full_name: 'The user', biography: "Hello", picture_url: "http://google.com", run_workshop_explaination: "❤️", password: "password", password_confirmation: "password"}

    result = User.new(default_attrs.merge(attrs))
    result.skip_confirmation!
    result.save!

    result
  end
end

