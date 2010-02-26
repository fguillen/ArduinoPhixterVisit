require 'rubygems'
require 'sinatra'
require "#{File.dirname(__FILE__)}/lib/scrappers/conjugation_org_scrapper.rb"

get '/:q' do
  socket = TCPSocket.open( '79.157.225.218', 20000 )
  socket.write( params[:q] )
  socket.close
end
