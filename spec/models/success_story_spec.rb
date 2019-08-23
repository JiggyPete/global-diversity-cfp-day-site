require 'rails_helper'

RSpec.describe SuccessStory, type: :model do

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

end

