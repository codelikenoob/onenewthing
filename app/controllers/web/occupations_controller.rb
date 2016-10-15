class Web::OccupationsController < Web::ApplicationController
  before_action :authenticate_user!

  def change_status
    occupation = Occupation.find(params[:id])
    authorize occupation
    occupation.status = occupation_params[:status].to_i
    if occupation.save
      redirect_to root_path # Change it later
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def occupation_params
    params.require(:occupation).permit(:status)
  end
end
