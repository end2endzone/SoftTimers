#include <SoftTimers.h>

#define LED_PIN_0 13
#define LED_PIN_1  8
#define LED_PIN_2  9

/**************************************************
 *Every second, cycle the HIGH pin within pins 13,8,9
 **************************************************/
SoftTimer cyclePinTimer; //millisecond timer

void setup() {
  pinMode(LED_PIN_0, OUTPUT);
  pinMode(LED_PIN_1, OUTPUT);
  pinMode(LED_PIN_2, OUTPUT);

  Serial.begin(115200);
  
  //update timers
  cyclePinTimer.setTimeOutTime(1000); // every 1 second.

  //start counting
  cyclePinTimer.reset();
}

void loop() {
  uint32_t loopCount = cyclePinTimer.getLoopCount();
  uint32_t pinHighNumber = (loopCount % 3); //from 0 to 2
  
  if (pinHighNumber == 0)
  {
    //turn ON the LED 0, turn OFF all other
    digitalWrite(LED_PIN_0, HIGH);
    digitalWrite(LED_PIN_1,  LOW);
    digitalWrite(LED_PIN_2,  LOW);
  }
  else if (pinHighNumber == 1)
  {
    //turn ON the LED 1, turn OFF all other
    digitalWrite(LED_PIN_0,  LOW);
    digitalWrite(LED_PIN_1, HIGH);
    digitalWrite(LED_PIN_2,  LOW);
  }
  else //if (pinHighNumber == 2)
  {
    //turn ON the LED 2, turn OFF all other
    digitalWrite(LED_PIN_0,  LOW);
    digitalWrite(LED_PIN_1,  LOW);
    digitalWrite(LED_PIN_2, HIGH);
  }
}

