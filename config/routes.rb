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
      resources :posts, except: [:new, :edit]
    end
  end

  get 'avatar', to: 'avatar#index'
  patch 'avatar', to: 'avatar#create'
end
