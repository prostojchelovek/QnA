Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :badges, only: [:index]
  concern :votable do
    member do
      post :vote_up, :vote_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch :choose_the_best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
