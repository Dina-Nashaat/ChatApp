require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :chats, param: :number do
    resources :messages, param: :number do
      collection do
        get :search
      end
    end
  end
  resources :applications, except: :update

  put '/applications', to: 'applications#update'
  patch '/applications', to: 'applications#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
