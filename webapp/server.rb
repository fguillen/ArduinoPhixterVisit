require 'rubygems'
require 'sinatra'

get '/:q' do
  socket = TCPSocket.open( '79.157.225.218', 20000 )
  socket.write( params[:q] )
  socket.close
end
