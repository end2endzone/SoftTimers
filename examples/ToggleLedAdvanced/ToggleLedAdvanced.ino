#include <SoftTimers.h>

#define LED_PIN 13

/**************************************************
 * Wait 1 second, turn on a LED for 0.3 second.
 **************************************************/
SoftTimer delayTimer; //millisecond timer
SoftTimer ledTimer;   //millisecond timer

void setup() {
  pinMode(LED_PIN, OUTPUT);

  Serial.begin(115200);
  
  //update timers
  delayTimer.setTimeOutTime(1000); // 1 second.
  ledTimer.setTimeOutTime(300); // 0.3 second.

  //start counting now
  delayTimer.reset();
  ledTimer.reset();
}

void loop() {  
  if (!delayTimer.hasTimedOut())
  {
    Serial.println("waiting...");

    //reset LED timer so that is does not time out before delayTimer
    ledTimer.reset();
  }

  //did we waited long enough ?
  else if (delayTimer.hasTimedOut() && !ledTimer.hasTimedOut())
  {
    Serial.println("turning LED ON...");

    //turn ON the LED
    digitalWrite(LED_PIN, HIGH);
  }

  //should the LED be turned OFF ?
  else if (delayTimer.hasTimedOut() && ledTimer.hasTimedOut())
  {
    Serial.println("turning LED OFF...");

    //turn OFF the LED
    digitalWrite(LED_PIN, LOW);

    //restart both timers
    delayTimer.reset();
    ledTimer.reset();
  }
}

