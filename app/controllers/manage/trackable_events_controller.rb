class Manage::TrackableEventsController < Manage::ApplicationController
  before_action :set_trackable_event, only: [:show, :edit, :update, :destroy]
  before_action :scope_limited_admin_access, only: [:edit, :update, :destroy]

  respond_to :html, :json

  # GET /manage/trackable_events
  def index
    @trackable_events = TrackableEvent.all
    respond_with(:manage, @trackable_events)
  end

  # GET /manage/trackable_events/1
  def show
    respond_with(:manage, @trackable_event)
  end

  # GET /manage/trackable_events/new
  def new
    trackable_tag_id = params[:trackable_tag_id]
    @trackable_event = TrackableEvent.new(trackable_tag_id: trackable_tag_id)
    respond_with(:manage, @trackable_event)
  end

  # GET /manage/trackable_events/1/edit
  def edit
  end

  # POST /manage/trackable_events
  def create
    @trackable_event = TrackableEvent.new(trackable_event_params.merge(user_id: current_user.id))

    if @trackable_event.save
      respond_to do |format|
        format.html { redirect_to manage_trackable_tag_path(@trackable_event.trackable_tag), notice: 'Trackable event was successfully created.' }
        format.json { render json: @trackable_event }
      end
    else
      render :new
    end
  end

  # PATCH/PUT /manage/trackable_events/1
  def update
    if @trackable_event.update(trackable_event_params)
      respond_to do |format|
        format.html { redirect_to manage_trackable_tag_path(@trackable_event.trackable_tag), notice: 'Trackable event was successfully updated.' }
        format.json { render json: @trackable_event }
      end
    else
      render :edit
    end
  end

  # DELETE /manage/trackable_events/1
  def destroy
    @trackable_event.destroy
    respond_to do |format|
      format.html { redirect_to manage_trackable_tag_url(@trackable_event.trackable_tag), notice: 'Trackable event was successfully destroyed.' }
      format.json { render json: @trackable_event }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trackable_event
    @trackable_event = TrackableEvent.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def trackable_event_params
    params.require(:trackable_event).permit(:band_id, :trackable_tag_id)
  end

  # Permit limited-access admins (overrides Manage::ApplicationController#limit_admin_access)
  def limit_admin_access
  end

  # If the admin is limited, scope changes only to those they created
  def scope_limited_admin_access
    return if !current_user.admin_limited_access || @trackable_event.blank? || @trackable_event.user.blank?
    redirect_to manage_trackable_events_path, notice: 'You may not view events you did not create.' if @trackable_event.user != current_user
  end
end
