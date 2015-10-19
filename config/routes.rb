Rails.application.routes.draw do


  devise_for :users

  get 'dashboard/' => 'dashboard#show', :as => :user_root

  get 'shared_notes/:id', to: 'shared_notes#show'

  root to: 'home#index'

  resources :tags, only: [:index, :show]

  resources :notes do
    collection do
      post :process_markdown
    end
    member do
      patch :share
      patch :unshare
    end
  end

  resources :trashed_notes, only: [:index, :destroy] do
    member do
      put :restore
    end
    collection do
      delete :empty
    end
  end

end
