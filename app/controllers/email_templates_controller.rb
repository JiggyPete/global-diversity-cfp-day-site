class EmailTemplatesController < ApplicationController
  def index
    @workshop = current_workshop
    path = File.join(Rails.root, "app", "views", "email_templates", (params[:template_name] + ".html.erb" ))
    @template = File.read(path)
    output = ERB.new(@template).result( binding )
    send_data(output,
         :filename    => (params[:template_name] + ".html"),
         :type => 'text/html'         )
  end
end
