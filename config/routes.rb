Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'
  resources :attachments, only: [:destroy]

  resources :questions do
    resources :answers, shallow: true do
      patch :choose_the_best, on: :member
    end
  end
end
