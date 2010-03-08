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
  
  def test_show
    phixter = Factory(:phixter)
    UserSession.create( phixter.user )
    
    get :show, :id => phixter
    assert_template 'show'
  end
  
  def test_new
    UserSession.create( Factory(:user) )
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Phixter.any_instance.stubs(:valid?).returns(false)
    
    UserSession.create( Factory(:user) )
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    phixter = Factory.build(:phixter)

    UserSession.create( phixter.user )
    assert_difference "Phixter.count", 1 do
      post :create, :phixter => {
        :uri => phixter.uri,
        :value => phixter.value
      }
    end

    assert_redirected_to phixter_url(assigns(:phixter))
    assert_equal( phixter.user, assigns(:phixter).user )
  end
  
  def test_edit
    phixter = Factory(:phixter)
    UserSession.create( phixter.user )
    
    get :edit, :id => Factory(:phixter)
    assert_template 'edit'
  end
  
  def test_update_invalid
    phixter = Factory(:phixter)
    
    Phixter.any_instance.stubs(:valid?).returns(false)
    
    UserSession.create( phixter.user )
    put :update, :id => phixter
    
    assert_template 'edit'
  end
  
  def test_update_valid
    phixter = Factory(:phixter)
    
    UserSession.create( phixter.user )
    put :update, :id => phixter, :phixter => { :uri => "new_uri:2000" }
    
    assert_redirected_to phixter_url(assigns(:phixter))
    phixter.reload
    assert_equal( "new_uri:2000", phixter.uri )
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
    10.times { Factory(:history_event, :phixter => phixter, :comment => 'wadus') }
    
    UserSession.create( phixter.user )
    get :history, :id => phixter
    assert_template 'history'
    
    event = HistoryEvent.last
    
    assert_match( event.created_at, @response.body )
    assert_match( event.status, @response.body )
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
    assert_match( phixter.uri, @response.body )
  end
  
  def test_code_if_not_correct_user_error
    phixter = Factory(:phixter)
    UserSession.create( phixter.user )
    
    get :code, :id => (phixter.id + 1)
  end
  
  def test_check
    phixter = Factory(:phixter)
    Phixter.any_instance.expects( :check ).returns( Phixter::STATUS[:OK] )
    UserSession.find.destroy 
       
    get :check, :id => phixter
    
    assert_equal( 'Check OK', flash[:notice] )
    assert_equal( 'Check completed', @response.body )
  end
  
  def test_check_with_error
    phixter = Factory(:phixter)
    Phixter.any_instance.expects( :check ).returns( Phixter::STATUS[:ERROR] )
    UserSession.find.destroy
    
    get :check, :id => phixter
    
    assert_equal( 'Check ERROR', flash[:alert] )
    assert_equal( 'Check completed', @response.body )
  end
end
