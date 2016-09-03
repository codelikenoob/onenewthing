Rails.application.routes.draw do
  scope module: 'web' do
    # Devise routing start
    devise_for :users, path: '',
      controllers: {
        sessions: 'custom_sessions',
        registrations: 'custom_registrations'
      },
      path_names: {
        sign_up: 'registration',
        sign_out: 'logout',
        sign_in: 'login'
      }
      # Devise routing end
  end
end

