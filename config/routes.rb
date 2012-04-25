Jams::Application.routes.draw do
  
  root :to => 'pages#home'
  
  resources :users
  match '/signup', :to => 'users#new'
   
  resources :videos
  match '/search', :to => 'videos#search'
  
  #match '/meta' => 'videos#new'
  
  #get "pages/home"
  #get "pages/user"

  #match '/user',  :to => 'pages#user'
  #match '/videos', :to => 'video#index'
  
  #get "pages/home"

end
