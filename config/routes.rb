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
        sign_out: 'logout',
        sign_in: 'login'
      }
      # Devise routing end
      resources :things
      patch '/occupations/:id/change_status' => 'occupations#change_status', as: 'change_status'
  end
end
