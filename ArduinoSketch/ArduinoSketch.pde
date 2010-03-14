/*
* Arduino Sketch for the PhixterVisits experiment.
* Author: http://fernandoguillen.info
* WebSite: http://fernandoguillen.info
*
* By Serial communication the Arduino receives numbers.
* From 1 to 12 (all the digital connections except the TX one).
*
* The leds from 2 to 13 will be turned on depending the number receive.
*
* value 1 is for led 2
* value 2 is for led 3
* ...
* not using led 1 because is the same of TX serial por communication
* 
*/

char val = 0;

long millis_on[12];
int times_on[12];
long millis_on_duration = 3000;
long millis_off_duration = 100;
long previous_millis = 0;
long loop_millis = 0;


void setup() {
  Serial.begin(9600);
  
  // initializing binary mode
  for( int n=2; n<=13; n++ ){
    pinMode(n, OUTPUT);
  }
  
  // initializing millis_on of every led
  for( int n=0; n<=11; n++ ){
    millis_on[n] = millis_on_duration;
  }
  
  // just for testing on 
  for( int n=2; n<=13; n++ ){
    digitalWrite(n, HIGH);
    delay(50);
    digitalWrite(n, LOW);
  }
  
  previous_millis = millis();
}

void loop() {
  loop_millis = millis() - previous_millis;
  previous_millis = millis();
  
  //
  // read the value sent through serial port
  // increment the times the led has to blink
  // 
  if( Serial.available() > 0 ) {
    val = Serial.read(); 
    Serial.print( val );        // return received value to client
    val = val - 47;             // converting '1' char to 2 int
    
    // incrementing the times the led has to blink
    if( val >= 2 && val <= 13 ) {
      times_on[val-2] += 1;
    }
  }
  
  for( int n=0; n<=11; n++ ){
    
    if( times_on[n] > 0 ){
      if( millis_on[n] > 0 ){
        digitalWrite( n+2, HIGH ); // remember the leds numeration starts on 2
      } else {
        digitalWrite( n+2, LOW );
      }
      
      // decrementing the available time for the led
      millis_on[n] -= loop_millis;
      
      //
      // there is a time the led if off even if it has
      // to blink agin
      //
      if( millis_on[n] < (-millis_off_duration) ){
        times_on[n] -= 1;
        millis_on[n] = millis_on_duration;  // reset millis_on of the led
      }      
    }
  }
  
  delay(100);
}


