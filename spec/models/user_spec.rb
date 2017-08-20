require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_one(:workshop)}
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:biography) }
    it { should validate_presence_of(:picture_url) }
    it { should validate_presence_of(:run_workshop_explaination) }

    context "picture_url" do
      it "accepts a valid url" do
        subject = User.new picture_url: "http://google.com"
        subject.valid?
        expect(subject.errors[:picture_url]).to be_empty
      end

      it "doesn't accept an invalid url" do
        subject = User.new picture_url: "invalid"
        subject.valid?
        expect(subject.errors[:picture_url]).to eql(["is not a valid URL"])
      end
    end
  end

  describe "#workshop" do
    context "when organiser" do
      it "provides the associated workshop" do
        organiser = create_user(email: 'organiser@example.com', organiser: true)
        workshop = Workshop.create organiser: organiser

        expect(organiser.workshop).to eql(workshop)
      end
    end

    context "when facilitator" do
      it "provides the associated workshop" do
        organiser = create_user(email: 'organiser@example.com', organiser: true)
        facilitator = create_user(email: 'facilitator@example.com', facilitator: true)
        workshop = Workshop.create organiser: organiser, facilitator: facilitator

        expect(facilitator.workshop).to eql(workshop)
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

