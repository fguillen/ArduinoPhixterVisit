require 'test_helper'

class PhixtersControllerTest < ActionController::TestCase
  setup :activate_authlogic
    
  def test_index
    user = Factory(:user)
    5.times{ Factory(:phixter, :user => user) }
    
    UserSession.create( user )
    get :index
    assert_template 'index'
    
    phixter = Phixter.last
    
    assert_match( phixter.id.to_s, @response.body )
    assert_match( phixter.uri, @response.body )
    assert_match( phixter.value, @response.body )
    assert_match( phixter.status.to_s, @response.body )
  end
  

  
  def test_create_invalid
    UserSession.create( Factory(:user) )
    post :create
    assert_template 'index'
  end
  
  def test_create_valid
    user = Factory(:user)
    UserSession.create( user )
    
    assert_difference "Phixter.count", 1 do
      post :create, :phixter => {
        :uri => '10.0.0.1:1',
        :value => '1'
      }
    end

    assert_template 'index'
    assert_equal( user, Phixter.last.user )
  end


  
  def test_destroy
    phixter = Factory(:phixter)
    UserSession.create( phixter.user )
    
    delete :destroy, :id => phixter
    
    assert_redirected_to phixters_url
    assert !Phixter.exists?(phixter.id)
  end
  
  def test_history
    phixter = Factory(:phixter)
    10.times { Factory(:history_event, :phixter => phixter, :comment => 'wadus', :status => 0) }
    UserSession.create( phixter.user )
    
    get :history, :id => phixter
    
    assert_template 'history'
    
    event = HistoryEvent.last
    
    assert_match( event.created_at.to_s(:date_time24), @response.body )
    assert_match( "phixter_visits_icon_status_#{event.status}.gif", @response.body )
    assert_match( event.comment, @response.body )
  end
  
  def test_on_index_only_show_current_user_phixters
    user_01 = Factory(:user)
    user_02 = Factory(:user)
    
    5.times{ Factory(:phixter, :user => user_01) }
    3.times{ Factory(:phixter, :user => user_02) }

    UserSession.create( user_01 )
    get :index
    assert_equal( user_01.phixters, assigns(:phixters) )
  end

  
  def test_code
    phixter = Factory(:phixter)
    UserSession.create( phixter.user )
    
    get :code, :id => phixter.id
    
    assert_template 'code'
    assert_match( signal_url( phixter.hash_code ), @response.body )
  end
  
  # def test_code_if_not_correct_user_error
  #   phixter = Factory(:phixter)
  #   UserSession.create( phixter.user )
  #   
  #   get :code, :id => (phixter.id + 1)
  # end
  
  def test_check
    phixter = Factory(:phixter)
    Phixter.any_instance.expects( :send_signal ).returns( Phixter::STATUS[:OK] )
    
    get :check, :id => phixter.hash_code
    
    assert_equal( 'Check OK', flash[:notice] )
    assert_redirected_to phixters_path
  end
  
  def test_check_with_error
    phixter = Factory(:phixter)
    Phixter.any_instance.expects( :send_signal ).returns( Phixter::STATUS[:ERROR] )
    
    get :check, :id => phixter.hash_code
    
    assert_equal( 'Check ERROR', flash[:alert] )
    assert_redirected_to phixters_path
  end
  
  def test_send_signal
    phixter = Factory(:phixter)
    Phixter.any_instance.expects( :send_signal )
    
    get :send_signal, :id => phixter.hash_code
    
    assert_equal( 'image/gif', @response.content_type )
  end
end
