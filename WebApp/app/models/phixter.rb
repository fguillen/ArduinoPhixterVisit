class Phixter < ActiveRecord::Base
  has_many :history_events
  belongs_to :user
  
  validates_presence_of :uri
  validates_presence_of :value
  
  validates_format_of :uri, :with => /\w+\.\w+:\d+/
  
  
  
  STATUS = {
    :UNKNOWN  => 0,
    :OK       => 1,
    :ERROR    => 2
  }
  
  def check
    socket = TCPSocket.open( self.uri_address, self.uri_port )
    socket.write( params[:q] )
    socket.close
  end
  
  def uri_address
    return self.uri.split(':')[0]
  end
  
  def uri_port
    return self.uri.split(':')[1]
  end
  
  def check
    begin
      socket = TCPSocket.open( self.uri_address, self.uri_port )
      socket.write( self.value )
      socket.close
      self.update_attribute( :status, Phixter::STATUS[:OK] )
      history_event = 
        HistoryEvent.create!(
          :status => Phixter::STATUS[:OK],
          :phixter => self
        )
    rescue Exception => e
      self.update_attribute( :status, Phixter::STATUS[:ERROR] )
      history_event = 
        HistoryEvent.create!(
          :status => Phixter::STATUS[:ERROR],
          :comment => e.message,
          :phixter => self
        )
    end
    
    return self.status
  end
end
