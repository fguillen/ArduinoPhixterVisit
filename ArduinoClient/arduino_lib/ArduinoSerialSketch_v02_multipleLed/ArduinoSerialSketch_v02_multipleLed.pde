/*
* Reflect serial input back.
*/

char val = 0;
int ledPin =  13;

void setup()
{
  Serial.begin(9600);
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  
  digitalWrite(13, HIGH);
  digitalWrite(12, HIGH);
  delay(500);
  digitalWrite(13, LOW);
  digitalWrite(12, LOW);
}

void loop()
{
  if( Serial.available() > 0 ) {
    val = Serial.read();

    if( val == '1' ) {
      digitalWrite( 13, HIGH );
      delay(1000);
      digitalWrite( 13, LOW );
    } else if( val == '2' ) {
      digitalWrite( 12, HIGH );
      delay(1000);
      digitalWrite( 12, LOW );
    }
    
    Serial.print( val );
  }
  
  delay(100);
}


