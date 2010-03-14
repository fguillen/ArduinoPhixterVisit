require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    User.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    User.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to phixters_path
  end
  
  def test_edit
    user = Factory(:user)
    UserSession.create( user )
    
    get :edit, :id => 'current'
    assert_template 'edit'
  end
  
  def test_update_invalid
    user = Factory(:user)
    UserSession.create( user )
    User.any_instance.stubs(:valid?).returns(false)
    
    put :update, :id => 'current'
    assert_template 'edit'
  end
  
  def test_update_valid
    user = Factory.build(:user)
    # puts "XXX: user.valid?: #{user.valid?}"
    # puts "XXX: #{user.errors.size}"
    
    UserSession.create( user )
    User.any_instance.stubs(:valid?).returns(true)
    
    put :update, :id => 'current'
    assert_redirected_to edit_user_path( user )
  end
  
  def test_destroy
    user = Factory(:user)
    UserSession.create( user )
    
    assert_difference "User.count", -1 do
      delete :destroy, :id => user
    end

    assert_nil( UserSession.find )
  end
end
