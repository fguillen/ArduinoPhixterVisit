class HistoryEvent < ActiveRecord::Base
  belongs_to :phixter
  after_create :crop_history_events
  
  def crop_history_events
    if( self.phixter.history_events.count > 150 ) # 50 elements of margin
      self.phixter.history_events.find(:all, :order => "created_at DESC", :offset => 100, :limit => 100).each do |history_event|
        history_event.destroy
      end
    end
  end
end
