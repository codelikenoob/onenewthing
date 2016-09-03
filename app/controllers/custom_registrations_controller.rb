class CustomRegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(users)
    # TODO: decide where to redirect user after sign up
    # return authenticated_root_url
    return root_url
  end

  private

  def sign_up_params
    params.require(:user)
          .permit(:name, :email, :password, :password_confirmation)
  end
end
