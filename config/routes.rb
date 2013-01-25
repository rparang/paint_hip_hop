Jams::Application.routes.draw do

  root :to => 'videos#home'
  
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
  match '/topdayjson', :to => 'videos#top_day_json'
  
  resources :sessions, :only => [:new, :create, :destroy]
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'

  resources :artists, :only => [:index, :show, :destroy]
  resources :authentications, :only => [:create, :destroy]
  resources :comments
  resources :relationships, :only => [:create, :destroy]
  resources :votes, :only => [:create, :destroy]

  match '/auth/:provider/callback' => 'authentications#create'

end
