class Manage::TrackableEventsController < Manage::ApplicationController
  before_action :set_trackable_event, only: [:show, :update, :destroy]
  before_action :scope_organizer_access, only: [:update, :destroy]

  respond_to :json

  # Retrieves all or the current user's TrackableEvent objects.
  # @param trackable_event [TrackableEvent, nil]  If a TrackableEvent is
  #                                               present only the current
  #                                               user's associated
  #                                               TrackableEvent objects will
  #                                               be retrieved.
  # @!method                                      index(trackable_event = nil)
  # @endpoint                                     /manage/trackable_events
  # @http_method                                  GET
  def index
    @trackable_events = TrackableEvent.all
    @params = {}
    if params[:trackable_event]
      @params = params.require(:trackable_event).permit(:user_id, :band_id, :trackable_tag_id).reject { |_, v| v.blank? }
      @trackable_events = @trackable_events.where(@params)
    end
  end

  # Retrieves information on a specific TrackableEvent.
  # @param id [Integer]  ID of the trackable event to show
  # @!method            show(id)
  # @endpoint           /manage/trackable_events/id
  # @http_method        GET
  def show
  end

  # Creates a new TrackableEvent object.
  # @endpoint           /manage/trackable_events
  # @http_method        POST
  # @return [200]       OK if TrackableEvent object was created
  # @return [422]       Unprocessable Entity if supplied TrackableEvent data
  #                     did not meet requirements or the saving process failed
  def create
    @trackable_event = TrackableEvent.new(trackable_event_params.merge(user_id: current_user.id))

    if @trackable_event.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # Updates a given TrackableEvent object.
  # @param id [Integer]   ID of the trackable event to update
  # @!method              update(id)
  # @endpoint             /manage/trackable_events/id
  # @http_method          PATCH
  # @http_method          PUT
  # @return [200]         OK if TrackableEvent object was updated
  # @return [422]         Unprocessable Entity if supplied TrackableEvent data
  #                       did not meet requirements or the saving process
  #                       failed
  def update
    if @trackable_event.update(trackable_event_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # Destroys a given TrackableEvent object.
  # @param id [Integer]   ID of the trackable event to destroy
  # @!method              destroy(id)
  # @endpoint             /manage/trackable_events/id
  # @http_method          DELETE
  # @return [200]         OK if TrackableEvent object was destroyed
  # @return [422]         Unprocessable Entity if the destroy process failed
  def destroy
    @trackable_event.destroy
    head :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_trackable_event
    @trackable_event = TrackableEvent.find_by(id: params[:id])
    head :not_found unless @trackable_event.present?
  end

  # Only allow a trusted parameter "white list" through.
  def trackable_event_params
    params.require(:trackable_event).permit(:band_id, :trackable_tag_id)
  end

  # Permit limited-access directors (overrides Manage::ApplicationController#limit_write_access_to_directors)
  def limit_write_access_to_directors
  end

  # If the user isn't a director, scope changes only to those they created
  def scope_organizer_access
    return if current_user.director? || @trackable_event.blank? || @trackable_event.user.blank?

    head :unauthorized if @trackable_event.user != current_user
  end
end
