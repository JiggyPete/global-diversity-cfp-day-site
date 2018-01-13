class CfpsController < ApplicationController

  def new
    @cfp = Cfp.new
  end

  def index
    @cfps = Cfp.cfps_grouped_for_homepage
  end

  def create
    @cfp = Cfp.new(cfp_params)

    respond_to do |format|
      if @cfp.save
        format.html do
          # redirect_to root_path, notice: 'CFP was successfully created.'
          redirect_to cfps_path, notice: 'CFP was successfully created.'
          # AdminMailer.cfp_created(@workshop, current_user).deliver
        end
        format.json { render :show, status: :created, location: @cfp }
      else
        format.html { render :new }
        format.json { render json: @cfp.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @cfp = Cfp.find(params[:id])
  end

  def edit
    @cfp = Cfp.find(params[:id])
  end

  def update
    @cfp = Cfp.find(params[:id])

    respond_to do |format|
      if @cfp.update(cfp_params)
        format.html do
          # redirect_to root_path, notice: 'CFP was successfully created.'
          redirect_to cfps_path, notice: 'CFP was successfully updated.'
          # AdminMailer.cfp_created(@workshop, current_user).deliver
        end
        format.json { render :show, status: :created, location: @cfp }
      else
        format.html { render :new }
        format.json { render json: @cfp.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cfp = Cfp.find(params[:id])
    if current_user.admin?
      flash[:notice] = @cfp.conference_name + "has been deleted"
      @cfp.destroy
    else
      flash[:error] = "You do not have permission to delete this event"
    end

    redirect_to cfps_path
  end

  private

  def cfp_params
    params.require(:cfp).permit(
      :conference_name,
      :cfp_url,
      :website,
      :twitter_handle,
      :cfp_open_date,
      :cfp_close_date,
      :event_start_date,
      :event_end_date,
      :continent,
      :country,
      :city,
      :code_of_conduct,
      :free_childcare,
      :free_childcare_notes,
      :financial_support_for_speakers,
      :financial_support_for_speakers_notes,
      :payment_for_speakers,
      :payment_for_speakers_notes
    )
  end

end
