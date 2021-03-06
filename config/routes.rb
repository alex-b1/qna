require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: "questions#index"

  post 'search', action: :search, controller: 'search'

  devise_for :users, controllers: {omniauth_callbacks: 'oauth_callbacks'}

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit], shallow: true
      end
    end
  end

  namespace :users do
    get '/set_email', to: 'emails#new'
    post '/set_email', to: 'emails#create'
  end

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  concern :commented do
    member do
      post :make_comment
    end
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :subscriptions, only: %i[create destroy], shallow: true
    resources :answers, concerns: [:voted, :commented] , shallow: true do
      member do
        post :mark_as_best
        post :make_comment
      end
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  mount ActionCable.server => '/cable'
end
