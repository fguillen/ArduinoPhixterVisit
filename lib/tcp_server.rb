# require 'socket'  
# streamSock = TCPSocket.new( "127.0.0.1", 20000 )  
# #streamSock.send( "Hello\n" )  
# str = streamSock.recv( 1 )  
# print str  
# streamSock.close


require 'socket'               # Get sockets from stdlib
require "#{File.dirname(__FILE__)}/arduino_serial_talker"

ast = ArduinoSerialTalker.new

server = TCPServer.open(20000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  puts "XXX: client accepted"
  
  char = client.getc.chr
  puts "XXX: client say: #{char}"
  
  ast.writeByte char
  
  client.close                 # Disconnect from the client
}
