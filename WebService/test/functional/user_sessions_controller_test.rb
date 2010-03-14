require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    user = Factory(:user)
    post :create, :user_session => {:email => user.email, :password => user.password}
    assert_redirected_to phixters_url
  end
  
  def test_destroy
    user = Factory(:user)
    UserSession.create( user )
    delete :destroy, :id => user
    assert_redirected_to root_url
    assert_nil UserSession.find
  end
end
