class PhixtersController < ApplicationController
  before_filter :require_user, :except => [:check, :send_signal]
  
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
      @phixter = nil
      flash.now[:notice] = "Successfully created phixter."
    else
      flash.now[:alert] = "Some error creating phixter."
    end
    
    @phixters = current_user.phixters
    render :action => :index
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
    @phixter = Phixter.find_by_hash_code(params[:id])
    
    if( !@phixter )
      flash[:alert] = 'Not Phixter found with that code'
    else
      if @phixter.send_signal == Phixter::STATUS[:OK]
        flash[:notice] = 'Check OK'
      else
        flash[:alert] = 'Check ERROR'
      end
    end
    
    redirect_to phixters_url
  end
  
  def send_signal
    @phixter = Phixter.find_by_hash_code(params[:id])
    @phixter.send_signal  if @phixter
    send_file "#{RAILS_ROOT}/public/images/phixter_visits_link_icon.gif", :disposition => 'inline', :type => 'image/gif'
  end
  
  def history
    @phixter = current_user.phixters.find(params[:id])
  end

end
