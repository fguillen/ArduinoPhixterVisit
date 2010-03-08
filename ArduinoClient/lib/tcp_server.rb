require 'socket'
require 'arduino_serial_talker'


class PhixterVisitClient
  def self.run( port = 20000 )
    ast = ArduinoSerialTalker.new
    server = TCPServer.open(port)

    puts "PhixterVisit Server listening on port: #{port}"

    loop {
      client = server.accept
      char = client.getc.chr
      client.close
  
      puts "Client send: #{char}"  
      ast.writeByte char
  
      char = ast.readByte
      puts "Arduino says: #{char.chr}"
    }
  end
end

PhixterVisitClient.run()

