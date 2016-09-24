class Web::ThingsController < Web::ApplicationController
  before_action :set_thing, only: [:show]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @things = Thing.all
  end

  def show; end

  def new
    @thing = Thing.new
  end

  def create
    thing = CreateOrAssociateThingWUser.new(current_user, thing_params).call
    if thing
      redirect_to thing_path(thing)
    else
      render :new
    end
  end

  def edit; end

  def update; end

  def destroy; end

  private

  def set_thing
    @thing = Thing.find(params[:id])
  end

  def thing_params
    params.require(:thing)
      .permit(:title, :description)
  end



end
