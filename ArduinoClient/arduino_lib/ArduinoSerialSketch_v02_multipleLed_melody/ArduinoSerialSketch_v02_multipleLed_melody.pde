/*
* Reflect serial input back.
*/

#include "pitches.h"

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
      playMelody1();
      digitalWrite( 13, LOW );
    } else if( val == '2' ) {
      digitalWrite( 12, HIGH );
      playMelody2();
      digitalWrite( 12, LOW );
    }
    
    Serial.print( val );
  }
  
  delay(100);
}

void playMelody1(){
  // notes in the melody:
  int melody[] = { NOTE_C4, NOTE_G3, NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4};

  // note durations: 4 = quarter note, 8 = eighth note, etc.:
  int noteDurations[] = { 4, 8, 8, 4, 4, 4, 4, 4 };
  
  playMelody( melody, noteDurations );
}

void playMelody2(){
  // notes in the melody:
  int melody[] = { NOTE_C4, NOTE_G3, NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_C4, NOTE_B3 };

  // note durations: 4 = quarter note, 8 = eighth note, etc.:
  int noteDurations[] = { 4, 8, 8, 4, 4, 4, 4, 4 };
  
  playMelody( melody, noteDurations );
}

void playMelody( int melody[], int noteDurations[] ){
    // iterate over the notes of the melody:
  for (int thisNote = 0; thisNote < 8; thisNote++) {

    // to calculate the note duration, take one second 
    // divided by the note type.
    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
    int noteDuration = 1000/noteDurations[thisNote];
    tone(8, melody[thisNote],noteDuration);

    // to distinguish the notes, set a minimum time between them.
    // the note's duration + 30% seems to work well:
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
  }
}


