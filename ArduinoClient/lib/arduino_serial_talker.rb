require 'rubygems'
require 'serialport'

class ArduinoSerialTalker
  SERIAL_PORT = '/dev/tty.usbserial-A900ae32'
  BAUD_RATE = 9600
  DATA_BITS = 8
  STOP_BITS = 1
  PARITY = SerialPort::NONE

  def initialize
    @serial_port = SerialPort.new( SERIAL_PORT, BAUD_RATE, DATA_BITS, STOP_BITS, PARITY )
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
  end
end

# ast = ArduinoSerialTalker.new
# 4.times do
#   ast.writeByte( '1' )
#   sleep( 0.5 )
#   ast.writeByte( '0' )
#   sleep( 0.5 )
# end
