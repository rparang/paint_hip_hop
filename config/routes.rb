Jams::Application.routes.draw do
  
  root :to => 'pages#home'
  
  resources :users do
    member do
      get :following, :followers
    end
  end

  match '/signup', :to => 'users#new'
   
  resources :videos
  match '/search', :to => 'videos#search'
  
  resources :sessions, :only => [:new, :create, :destroy]
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  resources :relationships, :only => [:create, :destroy]

  resources :votes, :only => [:create, :destroy]
  
  #match '/meta' => 'videos#new'
  
  #get "pages/home"
  #get "pages/user"

  #match '/user',  :to => 'pages#user'
  #match '/videos', :to => 'video#index'
  
  #get "pages/home"

end
