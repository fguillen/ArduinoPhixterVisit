ActionController::Routing::Routes.draw do |map|


  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"
  map.signal "signal/:id", :controller => "phixters", :action => "send_signal"
  
  map.resources :password_resets
  map.resources :user_sessions
  map.resources :phixters, :member => { :code => :get, :check => :get, :history => :get }  
  map.resources :users
  
  map.root :controller => "statics", :action => "home"

end
