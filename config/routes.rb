MyForum::Engine.routes.draw do
  root 'welcome#index'

  match 'signin', to: 'users#signin', via: [:get, :post]
  match 'logout', to: 'users#logout', via: [:get]

  match 'unread_topics', to: 'forums#unread_topics', via: [:get], as: :unread_topics
  match 'mark_all_as_read', to: 'forums#mark_all_as_read', via: [:get], as: :mark_all_as_read

  resources :users

  resources :forums, only: [:index, :show] do
    resources :topics do
      resources :posts
    end
  end

  namespace :admin do
    root 'dashboard#index'

    match 'forums', to: 'forums#index', via: [:get]

    resources :users
    resources :roles
    resources :categories do
      resources :forums
    end
  end
end
