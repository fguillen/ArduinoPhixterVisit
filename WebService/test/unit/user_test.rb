require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_validation
    user = Factory(:user)
    assert( user.valid? )
  end
  
  def test_destroy
    user = Factory(:user)
    phixter = Factory(:phixter, :user => user)
    history_event = Factory(:history_event, :phixter => phixter)
    
    assert_difference "User.count", -1 do
      assert_difference "Phixter.count", -1 do
        assert_difference "HistoryEvent.count", -1 do
          user.destroy
        end
      end
    end
  end
end
