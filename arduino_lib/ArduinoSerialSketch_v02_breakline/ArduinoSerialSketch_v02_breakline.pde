/*
* Reflect serial input back.
*/

char val = 0;
int ledPin =  13;

void setup()
{
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);
}

void loop()
{
  if( Serial.available() > 0 ) {
    val = Serial.read();

    if( val == '1' ) {
      digitalWrite( ledPin, HIGH );
    } else if( val == '0' ) {
      digitalWrite( ledPin, LOW );
    }
    
    Serial.println( val );
  }
  
  delay(100);
}


