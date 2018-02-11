#include <SoftTimers.h>

#define LED_PIN 9

/**************************************************
 *Fade a LED as the Fade basic example:
 *Increse the intensity of a LED from OFF to ON in 1 seconds
 *then ON to OFF in 1 seconds
 **************************************************/
SoftTimer fadeTimer; //millisecond timer

void setup() {
  pinMode(LED_PIN, OUTPUT);

  Serial.begin(115200);
  
  //update timers
  fadeTimer.setTimeOutTime(1000); // every 1 second.

  //start counting
  fadeTimer.reset();
}

void loop() {
  //determine the direction of brightness
  int direction = fadeTimer.getLoopCount() % 2; //returns 0 or 1
  bool increasing = (direction == 0); //assign increasing brightness with direction 0

  //get progress
  double progress = fadeTimer.getLoopProgress();

  //correct progress based on direction
  if (!increasing)
  {
    progress = 1.0 - progress;
  }

  //map progress to a 0-255 brightness intensity.
  uint16_t brightness = progress*255;
  
  //update the LED
  analogWrite(LED_PIN, brightness);
}

