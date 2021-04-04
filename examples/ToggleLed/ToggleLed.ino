#include <SoftTimers.h>

#define LED_PIN 13

/**************************************************
 *Every second, toggle a LED pin.
 **************************************************/
SoftTimer togglePinTimer; //millisecond timer

void setup() {
  pinMode(LED_PIN, OUTPUT);

  Serial.begin(115200);
  
  //update timers
  togglePinTimer.setTimeOutTime(1000); // every 1 second.

  //start counting
  togglePinTimer.reset();
}

void loop() {
  unsigned long loopCount = togglePinTimer.getLoopCount();
  bool pinHigh = ((loopCount % 2) == 0); //using 0 to get pin HIGH at the beginning of the sketch
  if (pinHigh)
  {
    //turn ON the LED
    digitalWrite(LED_PIN, HIGH);
  }
  else
  {
    //turn OFF the LED
    digitalWrite(LED_PIN, LOW);
  }
}

