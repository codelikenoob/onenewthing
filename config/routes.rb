Rails.application.routes.draw do
  scope module: 'web' do
    root to: 'static_pages#welcome'
    # Devise routing start
    devise_for :users, path: '',
      controllers: {
        sessions: 'custom_sessions',
        registrations: 'custom_registrations'
      },
      path_names: {
        sign_up: 'registration',
        sign_out: 'log_out',
        sign_in: 'log_in'
      }
      # Devise routing end
  end
end

