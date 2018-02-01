class AdminMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def workshop_created(workshop, user)
    @user = user
    @workshop = workshop
    mail(
      to: ENV["ADMIN_EMAIL_ADDRESS"],
      subject: "New workshop sign up!!!!!"
    )
  end

  def incident_created(incident)
    @incident = incident
    @link = incident_url(@incident)
    mail(
      to: "coc@globaldiversitycfpday.com",
      subject: "TEAM REPORTING Incident"
    )
  end
end
