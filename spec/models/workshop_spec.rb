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

  def create_user(attrs)
    default_attrs = {email: 'user@example.com', full_name: 'The user', biography: "Hello", picture_url: "http://google.com", run_workshop_explaination: "❤️", password: "password", password_confirmation: "password"}

    result = User.new(default_attrs.merge(attrs))
    result.skip_confirmation!
    result.save!

    result
  end
end

