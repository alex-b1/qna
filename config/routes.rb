Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers, shallow: true do
      member do
        post :mark_as_best
      end
    end
  end

  resources :attachments, only: :destroy
end
