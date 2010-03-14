class UsersController < ApplicationController
  before_filter :require_user, :only => [:edit, :udate, :destroy]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
      redirect_to phixters_path
    else
      flash.now[:alert] = "Some error trying to register."
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
    @user.email_confirmation = @user.email
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to edit_user_path( @user )
    else
      flash.now[:alert] = "Some error trying update info."
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = current_user
    @user.destroy
    flash[:notice] = 'User account deleted'
    
    user_session = UserSession.find
    user_session.destroy  if user_session
    
    redirect_to root_path
  end
end
