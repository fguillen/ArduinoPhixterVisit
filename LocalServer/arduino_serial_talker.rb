require 'rubygems'
require 'serialport'

class ArduinoSerialTalker
  attr_reader :serial_port_number
  
  @@instance = nil
  @serial_port_number = nil
  
  SERIAL_PORT = '/dev/tty.usbserial-A900ae32'
  BAUD_RATE = 9600
  DATA_BITS = 8
  STOP_BITS = 1
  PARITY = SerialPort::NONE
  
  def self.get_instance( serial_port_number = SERIAL_PORT )
    if( @@instance.nil? )
      @@instance = ArduinoSerialTalker.new( serial_port_number )
    elsif( @@instance.serial_port_number != serial_port_number )
      @@instance.close
      @@instance = ArduinoSerialTalker.new( serial_port_number )
    end
    
    return @@instance
  end
  
  def writeByte( byte )
    @serial_port.write( byte.to_s )
  end
  
  def readByte
    byte = @serial_port.getc;
    return byte
  end
  
  def close
    @serial_port.close
    @@instance = nil
  end
  
  private
    def initialize( serial_port_number = SERIAL_PORT )
      @serial_port_number = serial_port_number
      @serial_port = SerialPort.new( @serial_port_number, BAUD_RATE, DATA_BITS, STOP_BITS, PARITY )
    end
end
