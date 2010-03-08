require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_validation
    user = Factory(:user)
    assert( user.valid? )
  end
end
