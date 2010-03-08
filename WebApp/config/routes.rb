ActionController::Routing::Routes.draw do |map|
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
    
  map.resources :user_sessions
  map.resources :phixters, :member => { :code => :get, :check => :get, :history => :get }  
  map.resources :users
  
  map.root :controller => "statics", :action => "home"

end
