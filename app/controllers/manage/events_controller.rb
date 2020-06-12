class Manage::EventsController < Manage::ApplicationController

  respond_to :html, :json

  def index
    events = Event.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: Event.all }
    end
  end

  def new
    @event = ::Event.new
  end

  def create
    @event = ::Event.new(event_params)
    st = @event.start
    if @event.allDay and Time.at(@event.start).to_date === Time.at(@event.end).to_date
      @event.end = st
    end
    if @event.save
      redirect_to(manage_events_path)
    else
      render('new')
    end
  end

  def show
    @event = Event.find_by_id(params[:id])
    respond_with(:manage, @event)
  end

  def update
    @event = Event.find_by_id(params[:id])
    all_day_checked_params = event_params
    # full calendar will not render events that are marked all day but have different times in the same day
    if @event.allDay and Time.at(@event.start).to_date === Time.at(@event.end).to_date
      all_day_checked_params["end(1i)"] = all_day_checked_params["start(1i)"]
      all_day_checked_params["end(2i)"] = all_day_checked_params["start(2i)"]
      all_day_checked_params["end(3i)"] = all_day_checked_params["start(3i)"]
      all_day_checked_params["end(4i)"] = all_day_checked_params["start(4i)"]
      all_day_checked_params["end(5i)"] = all_day_checked_params["start(5i)"]
    end
    if @event.update(all_day_checked_params)
      redirect_to(manage_events_path)
    else
      render('show')
    end

  end

  def destroy
    @event = Event.find_by_id(params[:id])
    if @event.destroy
      redirect_to(manage_events_path)
    else
      render('show')
    end
  end

  def event_params
    params.require(:event).permit(
        :title, :description, :location, :owner, :allDay,:public ,:start, :end,
        )
  end
end
