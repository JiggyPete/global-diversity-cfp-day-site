class AdminMailer < ApplicationMailer
  def workshop_created(workshop, user)
    @user = user
    @workshop = workshop
    mail(
      to: ENV["ADMIN_EMAIL_ADDRESS"],
      subject: "New workshop sign up!!!!!"
    )
  end
end
