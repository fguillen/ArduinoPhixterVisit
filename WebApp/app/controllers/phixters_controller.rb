class PhixtersController < ApplicationController
  before_filter :logged_required, :except => [:check]
  
  def index
    @phixters = current_user.phixters
  end
  
  def show
    @phixter = current_user.phixters.find(params[:id])
  end
  
  def new
    @phixter = Phixter.new
  end
  
  def create
    @phixter = Phixter.new(params[:phixter])
    @phixter.user = current_user
    
    if @phixter.save
      flash[:notice] = "Successfully created phixter."
      redirect_to phixters_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @phixter = current_user.phixters.find(params[:id])
  end
  
  def update
    @phixter = current_user.phixters.find(params[:id])
    if @phixter.update_attributes(params[:phixter])
      flash[:notice] = "Successfully updated phixter."
      redirect_to phixters_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @phixter = current_user.phixters.find(params[:id])
    @phixter.destroy
    flash[:notice] = "Successfully destroyed phixter."
    redirect_to phixters_url
  end
  
  def code
    @phixter = current_user.phixters.find(params[:id])
  end
  
  def check
    @phixter = Phixter.find(params[:id])
    
    if @phixter.check == Phixter::STATUS[:OK]
      flash[:notice] = 'Check OK'
    else
      flash[:alert] = 'Check ERROR'
    end
    
    if( current_user )
      redirect_to phixters_url
    else
      render :text => 'Check completed'
    end
  end
  
  def history
    @phixter = current_user.phixters.find(params[:id])
  end

end
