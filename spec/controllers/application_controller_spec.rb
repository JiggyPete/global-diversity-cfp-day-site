require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "#after_sign_in_path_for" do
    context "user has just signed up" do
      it "sends them to the new workshop page" do
        user = User.new
        expect(controller.after_sign_in_path_for(user)).to eql(new_workshop_path)
      end
    end

    context "user has signed in having previously created a workshop" do
      it "sends them to the new workshop page" do
        workshop = Workshop.new(id: 5)
        user = User.new workshop: workshop
        expect(controller.after_sign_in_path_for(user)).to eql( workshop_path(workshop) )
      end
    end
  end

end
