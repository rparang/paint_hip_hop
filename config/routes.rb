Jams::Application.routes.draw do
  
  get "authentications/index"

  get "authentications/create"

  get "authentications/destroy"

  root :to => 'pages#home'
  
  resources :users do
    member do
      get :following, :followers
    end
  end

  match '/signup', :to => 'users#new'
   
  resources :videos
  match '/post', :to => 'videos#search'
  match '/day', :to => 'videos#top_day'
  match '/week', :to => 'videos#top_week'
  match '/month', :to => 'videos#top_month'
  match '/alltime', :to => 'videos#top_alltime'
  
  resources :sessions, :only => [:new, :create, :destroy]
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  resources :relationships, :only => [:create, :destroy]

  resources :votes, :only => [:create, :destroy]

  resources :comments
  resources :authentications, :only => [:index, :create, :destroy]

  match '/auth/:provider/callback' => 'authentications#create'

end
