Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

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
