# require 'socket'  
# streamSock = TCPSocket.new( "127.0.0.1", 20000 )  
# #streamSock.send( "Hello\n" )  
# str = streamSock.recv( 1 )  
# print str  
# streamSock.close


require 'socket'               # Get sockets from stdlib

server = TCPServer.open(20000)  # Socket to listen on port 2000
loop {                         # Servers run forever
  client = server.accept       # Wait for a client to connect
  puts "XXX: client accepted"
  puts "XXX: client say: #{client.getc}"
  client.close                 # Disconnect from the client
}
