import processing.serial.*;

Serial port;
PFont font;
int textPosition = 40;
int textPositionStep = 10;


void setup(){
  size( 640, 480 );
  frameRate( 10 );
  font = loadFont( "HelveticaNeue-10.vlw" );
  fill( 255 );
  textFont( font, 10 );
  
//  println( Serial.list() );
  String arduinoPort = Serial.list()[0];

  port = new Serial( this, arduinoPort, 9600 );

  writeText( "Testing Serial Arduino Communication" );
}

void draw() {

  
  if ( port.available() > 0 ) {
    int readByte = port.read();
    writeText( "Receiving: " + readByte );
//    port.clear();
  }
}

void writeText( String _text ){
  text( _text, 10, textPosition );
  textPosition += textPositionStep;
  
  if( textPosition >= 400 ){
    fill( 0 );
    rect( 0, 0, 640, 480 );
    fill( 255 );
    textPosition = 0;
  }
}

void keyPressed() {
  writeText( "Writing: " + key );
  port.write( key );
  
}
