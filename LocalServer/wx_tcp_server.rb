require 'rubygems'
require 'socket'
require 'arduino_serial_talker'
require 'wx'

class SerialTalkerThread
  def run( arduino_serial_port, tcp_listening_port, my_frame )
    puts "SerialTalkerThread::run"
    
    Thread.new do
      ast = ArduinoSerialTalker.get_instance( arduino_serial_port )
      server = TCPServer.open(tcp_listening_port)

      my_frame.log_ctrl.append_text "PhixterVisit Server listening on port: #{tcp_listening_port}\n"

      loop {
        my_frame.log_ctrl.append_text "Thread acepting client\n"  
        client = server.accept
        my_frame.log_ctrl.append_text "Thread client acepted\n"
        char = client.getc.chr
        my_frame.log_ctrl.append_text "Closing client.\n"
        client.close
        my_frame.log_ctrl.append_text "Client closed.\n"        
        
        # # changing icon
        # my_frame.icon_bitmap.set_bitmap( my_frame.icon_alert )

        my_frame.log_ctrl.append_text "Client send: #{char}\n"  
        ast.writeByte char
        my_frame.log_ctrl.append_text "Value sent to Arduino\n"        

        char = ast.readByte
        my_frame.log_ctrl.append_text "Arduino says: #{char.chr}\n"
        
        # # changing icon
        # my_frame.icon_bitmap.set_bitmap( my_frame.icon_listening )
      }
    end
  end
end


class WXTCPServer < Wx::App
  def on_init
    my_frame = 
      MyFrame.new(
        :title => "PhixterVisits Local Server",
        :pos => [ 50, 50 ],
        :size => [ 500, 500 ],
        :style => Wx::DEFAULT_FRAME_STYLE ^ Wx::RESIZE_BORDER
      )
    
    my_frame.show
  end
end

class MyFrame < Wx::Frame
  attr_accessor :log_ctrl, :icon_listening, :icon_alert, :icon_bitmap
  
  @listening = false;
  
  
  def initialize(*args)
    super(nil, *args)
    

    
    @panel = Wx::Panel.new(self)
    @panel.set_background_colour( Wx::Colour.new( 251, 176, 64 ) )
    
    
    @grid_sizer = Wx::BoxSizer.new( Wx::VERTICAL )
    @header_sizer = Wx::BoxSizer.new( Wx::HORIZONTAL )
    @controls_sizer = Wx::BoxSizer.new( Wx::VERTICAL )
    @controls_serial_port_sizer = Wx::BoxSizer.new( Wx::HORIZONTAL )
    @controls_listen_sizer = Wx::BoxSizer.new( Wx::HORIZONTAL )
    @controls_test_sizer = Wx::BoxSizer.new( Wx::HORIZONTAL )
    
    @grid_sizer.add( @header_sizer, 2 )
    @grid_sizer.add( @controls_sizer, 1, Wx::GROW|Wx::ALL, 10 )
    @controls_sizer.add( @controls_serial_port_sizer, 1, Wx::GROW )
    @controls_sizer.add( @controls_listen_sizer, 1, Wx::GROW )
    @controls_sizer.add( @controls_test_sizer, 1, Wx::GROW )
    
    ## font
    font = Wx::Font.new(12, Wx::FONTFAMILY_SWISS, Wx::FONTSTYLE_NORMAL, Wx::FONTWEIGHT_BOLD)
    
    ## icons
    @icon_off = Wx::Bitmap.new( File.join( File.dirname(__FILE__), 'graphics', 'icon_off.png' ), Wx::BITMAP_TYPE_PNG )
    @icon_listening = Wx::Bitmap.new( File.join( File.dirname(__FILE__), 'graphics', 'icon_listening.png' ), Wx::BITMAP_TYPE_PNG )
    @icon_alert = Wx::Bitmap.new( File.join( File.dirname(__FILE__), 'graphics', 'icon_alert.png' ), Wx::BITMAP_TYPE_PNG )
    
    
    ## icons header
    @icon_bitmap = Wx::StaticBitmap.new( @panel, -1, @icon_off, Wx::DEFAULT_POSITION )
    @header_sizer.add( @icon_bitmap, 1, Wx::ALIGN_CENTRE|Wx::ALL, 0 )
    
    ## listen label
    @listen_label = Wx::StaticText.new( @panel, -1, "Port to listen" )
    @listen_label.set_font( font )
    @controls_listen_sizer.add( @listen_label, 2, Wx::LEFT|Wx::RIGHT, 10 )
    
    ## listen text ctrl
    @listen_port_ctrl = Wx::TextCtrl.new( @panel )
    @controls_listen_sizer.add( @listen_port_ctrl, 1, Wx::LEFT|Wx::RIGHT, 10 )
    
    ## listen button
    @listen_button = Wx::Button.new( @panel, :label => 'listen' )
    @controls_listen_sizer.add( @listen_button, 1, Wx::LEFT|Wx::RIGHT, 10 )
    evt_button( @listen_button, :on_listen )
    
    
    ## serial port label
    @serial_port_label = Wx::StaticText.new( @panel, -1, "Arduino Serial Port" )
    @serial_port_label.set_font( font )
    @controls_serial_port_sizer.add( @serial_port_label, 1, Wx::LEFT|Wx::RIGHT, 10 )
    
    ## serial port text ctrl
    @serial_port_ctrl = Wx::TextCtrl.new( @panel, -1, "/dev/tty.usbserial-A900ae32" )
    @controls_serial_port_sizer.add( @serial_port_ctrl, 1, Wx::LEFT|Wx::RIGHT, 10 )
    
    ## test label
    @test_label = Wx::StaticText.new( @panel, -1, "Send test value" )
    @test_label.set_font( font )
    @controls_test_sizer.add( @test_label, 1, Wx::LEFT|Wx::RIGHT, 10 )
    
    ## test buttons
    @test_buttons_sizer = Wx::BoxSizer.new( Wx::HORIZONTAL )
    (1..6).each do |number|
      test_button = Wx::Button.new( @panel, :label => number.to_s )
      @test_buttons_sizer.add( test_button, 1, Wx::LEFT|Wx::RIGHT, 2 )
      evt_button(test_button) { | event | on_test_button_pressed(number) }
    end
    @controls_test_sizer.add( @test_buttons_sizer, 1, Wx::LEFT|Wx::RIGHT, 10 )
                
    ## log text ctrl                   
    @log_ctrl = Wx::TextCtrl.new( @panel, :style => Wx::TE_READONLY|Wx::TE_MULTILINE )
    @grid_sizer.add( @log_ctrl, 2, Wx::GROW|Wx::ALL, 10 )
    
    @panel.sizer = @grid_sizer
    
    ## on close
    evt_close :on_close
  end
  
  def on_listen
    if( !@listening )
      @log_ctrl.append_text( "Trying to listen on port: #{@listen_port_ctrl.get_value}\n" )
      @serial_talker_thread = SerialTalkerThread.new.run( @serial_port_ctrl.get_value, @listen_port_ctrl.get_value, self )
      @listen_button.label = "stop"
      @listen_port_ctrl.set_editable( false )
      @icon_bitmap.set_bitmap( @icon_listening )
      @listening = true
    else
      @log_ctrl.append_text( "Trying to stop listening\n" )
      @serial_talker_thread.exit
      @listen_button.label = "listen"
      @listen_port_ctrl.set_editable( true )
      @log_ctrl.append_text( "Stop listening\n" )
      @icon_bitmap.set_bitmap( @icon_off )
      @listening = false
    end
  end
  
  def on_test_button_pressed( value )
    @log_ctrl.append_text "Sending test value to Arduino: #{value}\n"
    begin
      ArduinoSerialTalker.get_instance(@serial_port_ctrl.get_value).writeByte( value )
    rescue Exception => e
      @log_ctrl.append_text( "Error sending test value to Arduino: #{e.message}\n" )
    end
  end
  
  def on_close( event )
    ArduinoSerialTalker.get_instance(@serial_port_ctrl.get_value).close
    puts "Closing PhixterVisits Local Server"
    event.skip
  end
end


WXTCPServer.new.main_loop

