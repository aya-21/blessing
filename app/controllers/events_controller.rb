class EventsController < ApplicationController
  # GET /events/new
  def new
    # @event = Event.new
  end

  # POST /events
  def create
    # @event = Event.new(event_params)
    # if @event.save
    #   redirect_to @event, notice: 'Event was successfully created.'
    # else
    #   render :new
    # end
  end

  # GET /events
  def index
  #   @events = Event.all
  end

  # GET /events/:id
  def show
    # @event = Event.find(params[:id])
  end

  # GET /events/:id/edit
  def edit
    # @event = Event.find(params[:id])
  end

  # private

  # Only allow a list of trusted parameters through.
  # def event_params
  #   params.require(:event).permit(:event_name, :date_at)
  # end
end
