class CustomSessionsController < Devise::SessionsController
  def after_sign_in_path_for(users)
    # TODO: decide where to redirect user after sign in
    # return authenticated_root_url
    flash[:success] = "Welcome, #{current_user.name}!"
    return root_url
  end
end
