MyForum::Engine.routes.draw do
  root 'welcome#index'

  match 'signin', to: 'users#signin', via: [:get, :post]
  match 'logout', to: 'users#logout', via: [:get]
  match 'forgot_password', to: 'users#forgot_password', via: [:get, :post]

  match 'unread_topics', to: 'forums#unread_topics', via: [:get], as: :unread_topics
  match 'mark_all_as_read', to: 'forums#mark_all_as_read', via: [:get], as: :mark_all_as_read

  resources :users do
    collection do
      get :autocomplete
    end
  end
  resources :private_messages

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
