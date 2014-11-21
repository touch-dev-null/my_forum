MyForum::Engine.routes.draw do
  root 'welcome#index'

  match 'signin', to: 'users#signin', via: [:get, :post]
  match 'logout', to: 'users#logout', via: [:get]

  resources :forums, only: [:index, :show] do
    resources :topics do
      resources :posts
    end
  end

  namespace :admin do
    root 'dashboard#index'

    match 'forums', to: 'forums#index', via: [:get]

    resources :categories do
      resources :forums
    end
  end
end
