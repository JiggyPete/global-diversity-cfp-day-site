require 'rails_helper'

RSpec.describe User, type: :model do
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
end

