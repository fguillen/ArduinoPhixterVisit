require 'test_helper'

class PasswordResetsControllerTest < ActionController::TestCase
  def setup
    ActionMailer::Base.deliveries = []
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_valid
    user = Factory(:user)
    
    post :create, :user => { :email => user.email }
    
    assert( !ActionMailer::Base.deliveries.empty? )
    assert_not_nil( flash[:notice] )
    assert_redirected_to( root_url )
  end
  
  def test_edit
    user = Factory(:user )
    get :edit, :id => user.perishable_token
    assert_template 'edit'
  end
  
  def test_update_invalid
    user = Factory(:user )
    put :update, :id => user.perishable_token
    
    assert_redirected_to( edit_password_reset_path( user.perishable_token ) )
    assert_not_nil( flash[:alert] )
  end
  
  def test_update_valid
    user = Factory(:user, :perishable_token => 'wadus_token' )
    
    put( 
      :update, 
      :id => user.perishable_token,
      :user => {
        :password => 'other',
        :password_confirmation => 'other'
      }
    )
    
    assert_not_nil( flash[:notice] )
    assert_redirected_to phixters_path
  end
end
