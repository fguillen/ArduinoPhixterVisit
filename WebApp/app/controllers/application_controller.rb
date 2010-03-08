# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password
  
  helper_method :current_user
  helper_method :current_user_name
  

  private
    def current_user_session
      @current_user_session = UserSession.find  unless defined?(@current_user_session)
      return @current_user_session
    end
    
    def current_user
      return @current_user  if defined?(@current_user)
      
      if current_user_session
        @current_user = current_user_session.record
        return @current_user
      else
        return nil
      end
    end
    
    def current_user_name
      return nil  if !current_user_session
      return current_user.email
    end
    
    def logged_required
      if( !current_user )
        session[:lost_url] = request.request_uri
        flash[:alert] = 'You need to be logged to access there.'
        redirect_to login_path
      end
    end
end
