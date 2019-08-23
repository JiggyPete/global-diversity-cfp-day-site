require 'rails_helper'

RSpec.describe SuccessStory, type: :model do

  def create_success_story(attributes)
    default_attributes = {
    full_name: "Fiona McDaid",
    profile_picture_url: "https://twitter.com/fiona/profile_pic.jpg",
    email_address: "fiona@gmail.com",
    talk_title: "My Awesome Talk",
    event_name: "The Tech Conference",
    event_start_date: Date.new,
    event_end_date: Date.new,
    premission_for_public_use: true,
    approved: true

    }

    SuccessStory.create( default_attributes.merge(attributes) )
  end

  describe "validations" do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:profile_picture_url) }
    it { should validate_presence_of(:email_address) }
    it { should validate_presence_of(:talk_title) }
    it { should validate_presence_of(:event_name) }
    it { should validate_presence_of(:event_start_date) }
    it { should validate_presence_of(:event_end_date) }
    it { should validate_presence_of(:premission_for_public_use) }
    it { should validate_presence_of(:approved) }


    context "profile_picture_url" do
      it "accepts a valid url" do
        subject = described_class.new profile_picture_url: "http://google.com"
        subject.valid?
        expect(subject.errors[:profile_picture_url]).to be_empty
      end

      it "doesn't accept an invalid url" do
        subject = described_class.new profile_picture_url: "invalid"
        subject.valid?
        expect(subject.errors[:profile_picture_url]).to eql(["is not a valid URL"])
      end
    end
  end

  describe "upcoming" do
    context "with no success stories" do
      it "provides no success stories" do
        expect(SuccessStory.upcoming.length).to eql(0)
      end
    end

    context "with past success stories" do
      context "with one past success story" do
        it "provides no upcoming success stories" do
          create_success_story event_start_date: Date.yesterday
          expect(SuccessStory.upcoming.length).to eql(0)
        end
      end

      context "with two past success story" do
        it "provides no success stories" do
          create_success_story event_start_date: Date.yesterday
          create_success_story event_start_date: 2.days.ago

          expect(SuccessStory.upcoming.length).to eql(0)
        end
      end

      context "with three past success story" do
        it "provides no success stories" do
          create_success_story event_start_date: Date.yesterday
          create_success_story event_start_date: 2.days.ago
          create_success_story event_start_date: 3.days.ago

          expect(SuccessStory.upcoming.length).to eql(0)
        end
      end
    end

    context "with a success story today" do
      it "provides upcoming success stories" do
        create_success_story event_start_date: Date.today
        expect(SuccessStory.upcoming.length).to eql(1)
      end
    end

    context "with multiple success stories today" do
      it "provides upcoming success stories" do
        create_success_story event_start_date: Date.today
        create_success_story event_start_date: Date.today
        create_success_story event_start_date: Date.today
        expect(SuccessStory.upcoming.length).to eql(3)
      end
    end

    context "with multiple success stories today with multiple past success stories" do
      it "provides upcoming success stories" do
        create_success_story event_start_date: Date.yesterday
        create_success_story event_start_date: Date.yesterday
        create_success_story event_start_date: Date.today, full_name: "Todays First Success"
        create_success_story event_start_date: Date.today, full_name: "Todays Second Success"
        create_success_story event_start_date: Date.today, full_name: "Todays Third Success"

        names = SuccessStory.upcoming.map(&:full_name)
        names.each do |name|
          expect( ["Todays First Success", "Todays Second Success", "Todays Third Success"] ).to include(name)
        end
      end
    end

    context "with multiple future success stories" do
      it "provides upcoming success stories" do
        create_success_story event_start_date: Date.today
        create_success_story event_start_date: Date.tomorrow
        create_success_story event_start_date: Date.tomorrow

        expect(SuccessStory.upcoming.length).to eql(3)
      end
    end

    context "with multiple future success stories" do
      it "only provides upcoming success stories with premission_for_public_use" do
        create_success_story event_start_date: Date.tomorrow, premission_for_public_use: false
        create_success_story event_start_date: Date.tomorrow, premission_for_public_use: true
        create_success_story event_start_date: Date.tomorrow, premission_for_public_use: true

        expect(SuccessStory.upcoming.length).to eql(2)
      end

      it "only provides approved upcoming success stories" do
        create_success_story event_start_date: Date.tomorrow, approved: false
        create_success_story event_start_date: Date.tomorrow, approved: true
        create_success_story event_start_date: Date.tomorrow, approved: true

        expect(SuccessStory.upcoming.length).to eql(2)
      end

      it "limits upcoming success stories to nearest three" do
        create_success_story event_start_date: 4.days.from_now, full_name: "Not returned"

        create_success_story event_start_date: 2.days.from_now, full_name: "Second"
        create_success_story event_start_date: 1.day.from_now, full_name: "First"
        create_success_story event_start_date: 3.days.from_now, full_name: "Third"

        expect(SuccessStory.upcoming.length).to eql(3)
        expect(SuccessStory.upcoming[0].full_name).to eql("First")
        expect(SuccessStory.upcoming[1].full_name).to eql("Second")
        expect(SuccessStory.upcoming[2].full_name).to eql("Third")
      end
    end
  end

end

