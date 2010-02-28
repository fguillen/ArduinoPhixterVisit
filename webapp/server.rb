require 'rubygems'
require 'sinatra'

get '/:q' do
  socket = TCPSocket.open( 'fguillen.no-ip.org', 20000 )
  socket.write( params[:q] )
  socket.close
end
