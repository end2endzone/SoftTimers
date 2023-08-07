#include <SoftTimers.h>

#define ANALOG_PIN A0

/*************************************************************
 * Read an analog pin and print its value on the serial port.
 * Use a SoftTimer to prevent printing too many messages by
 * limitting to a maximum of 1 message every 500 millisecond.
 ************************************************************/
SoftTimer silent_timer; //millisecond timer

void setup() {
  pinMode(ANALOG_PIN, INPUT);

  Serial.begin(115200);
  Serial.println("ready");

  // force timer to be in "timed out" state
  silent_timer.setTimeOutTime(1);
  silent_timer.reset();
  delay(2);

  // update timer with actual minimum delay between prints 
  silent_timer.setTimeOutTime(500); // every 500 milliseconds.

  // start counting
  silent_timer.reset();
}

void loop() {
  // read a new value every loop
  int pin_value = analogRead(ANALOG_PIN);

  // can we print its value to the serial port?
  // have we been "silent" enough?
  if (silent_timer.hasTimedOut()) {
    // yes! print a new value
    Serial.print("pin_value=");
    Serial.println(pin_value);

    // remember that we just printed to the serial port
    silent_timer.reset();
  }

}

