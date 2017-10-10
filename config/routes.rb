Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # user auth
      post    'auth', to: 'auth#login'
      delete  'auth', to: 'auth#destroy_tokens'

      resources :users, except: [:new, :edit] do
        member do
          put :change_role
        end
      end
    end
  end
end
