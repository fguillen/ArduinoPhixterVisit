class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.find_by_email(params[:user][:email])  
    
    if @user  
      @user.deliver_password_reset_instructions!  
      flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
      redirect_to root_url  
    else  
      flash[:alert] = "No user was found with that email address."
      @user = User.new( :email => params[:email] )
      render :action => :new  
    end
  end
  
  def edit
    @user = User.new
  end
  
  def update
    if( !params[:user] || params[:user][:password].empty? )
      flash[:alert] = 'You have to fill the passwords fields'
      redirect_to edit_password_reset_path( params[:id] )
      return
    end
    
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    
    if @user.save  
      flash[:notice] = "Password successfully updated."
      redirect_to phixters_path
    else  
      flash[:alert] = "Some errors trying to reset your password."
      render :action => :edit  
    end
  end
  
  private  
    def load_user_using_perishable_token  
      @user = User.find_using_perishable_token(params[:id], 7200)  
      
      if !@user  
        flash[:alert] = 
          "We're sorry, but we could not locate your account. " +  
          "If you are having issues try copying and pasting the URL " +  
          "from your email into your browser or restarting the " +  
          "reset password process."  
      
        redirect_to root_url  
      end
    end
end
