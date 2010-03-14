class Phixter < ActiveRecord::Base
  has_many :history_events, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :uri
  validates_presence_of :value
  validates_uniqueness_of :hash_code, :message => 'el hash code'
  
  validates_format_of :uri, :with => /\w+\.\w+:\d+/, :message => 'has to be ip:port like this myip.com:2000'
  after_create :initialize_hash_code
  before_validation :initialize_status
  
  
  
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
  
  def send_signal
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
  
  def initialize_hash_code
    if( self.hash_code.nil? )
      self.update_attribute( :hash_code, "#{Digest::MD5.hexdigest( "#{Time.now}#{rand}" )[1..5]}#{self.id}" )
    end
  end
  
  def initialize_status
    self.status ||= Phixter::STATUS[:UNKNOWN]
  end
end
