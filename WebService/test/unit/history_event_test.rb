require 'test_helper'

class HistoryEventTest < ActiveSupport::TestCase
  def test_crop_history_events
    phixter = Factory(:phixter)
    
    150.times { Factory(:history_event, :phixter => phixter) }
    
    assert_difference "HistoryEvent.count", -50 do
      Factory(:history_event, :phixter => phixter)
    end
  end
end
