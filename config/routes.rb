MyForum::Engine.routes.draw do
  root 'welcome#index'

  resources :forums, only: [:index, :show] do
    resources :topics
  end

  namespace :admin do
    root 'dashboard#index'

    match 'forums', to: 'forums#index', via: [:get]

    resources :categories do
      resources :forums
    end
  end
end
