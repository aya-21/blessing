class EventsController < ApplicationController
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to new_event_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end 

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(:event_name, :date_at)
  end
end
