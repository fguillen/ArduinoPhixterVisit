require 'socket'

socket = TCPSocket.open( 'localhost', 20000 )
socket.write( '1' )
socket.close

socket = TCPSocket.open( 'localhost', 20000 )
socket.write( '0' )
socket.close
