#include <SoftTimers.h>

/**************************************************
 *Show a progress bar on the serial port.
 **************************************************/
SoftTimer barTimer; //millisecond timer

void setup() {
  Serial.begin(115200);
  
  //update timers
  barTimer.setTimeOutTime(5000); // every 5 second.

  //start counting
  barTimer.reset();
}

const int MAX_BAR_LENGTH = 91; //bar has 30 character max
char barText[MAX_BAR_LENGTH];
char barCharacter = '*';

void loop() {
  if (barTimer.getLoopCount() >= 3)
  {
    barTimer.reset();
  }
  
  //build a new progress bar
  memset(barText, 0, MAX_BAR_LENGTH);
  
  //get progress
  double progress = barTimer.getProgress();

  //convert progress to a bar length
  int numBar = progress*(MAX_BAR_LENGTH-1);

  //fill progress bar
  for(int i=0; i<numBar; i++)
  {
    barText[i] = barCharacter;
  }

  //show progress bar
  Serial.println(barText);
}

