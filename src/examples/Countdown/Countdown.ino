#include <SoftTimers.h>

#define LED_PIN 13

/**************************************************
 * Run a countdown from 5 second to 0 and turn LED on
 **************************************************/
SoftTimer countdown; //millisecond timer

void setup() {
  pinMode(LED_PIN, OUTPUT);

  Serial.begin(115200);
  
  //update timers
  countdown.setTimeOutTime(5000); // 5 seconds
  
  //start counting now
  countdown.reset();
}

void loop() {
  if (!countdown.hasTimedOut())
  {
    //show user how much time left in milliseconds
    uint32_t remaining = countdown.getRemainingTime();
    Serial.print(remaining);
    Serial.println(" ms...");
  }
  else
  {
    //turn ON the LED
    digitalWrite(LED_PIN, HIGH);
  }
}

