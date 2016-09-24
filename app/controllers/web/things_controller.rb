class Web::ThingsController < Web::ApplicationController
  before_action :set_thing, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @things = Thing.all
  end

  def show; end

  def new
    @thing = Thing.new
  end

  def create
    thing = Thing.create_or_associate(thing_params, current_user)
    if thing
      redirect_to thing_path(thing)
    else
      render :new
    end
  end

  def edit
    authorize @thing
  end

  def update
    authorize @thing
    if Thing.create_or_associate(thing_params, current_user)
      current_user.things.delete(@thing)
    else
      render :edit
    end
  end

  def destroy
    authorize @thing
    @thing.users.delete(current_user)
  end

  private

  def set_thing
    @thing = Thing.find(params[:id])
  end

  def thing_params
    params.require(:thing)
          .permit(:title, :description)
  end
end
