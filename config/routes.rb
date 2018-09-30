Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :groups
      resources :users
    end
  end

  post '/login', to: 'auth#login'
  get '/current_user', to: 'auth#currentUser'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
