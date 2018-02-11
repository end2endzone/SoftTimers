#include <SoftTimers.h>

/**************************************************
 * An hypothetical state machine needs to step from 
 * state to state. Each state has its own maximum 
 * duration:
 * State #1 - IDLE (1000 ms)
 * State #2 - LISTENING (200 ms)
 * State #3 - SYNCHRONIZING (500 ms)
 * State #4 - UPDATING (300 ms)
 * State #1 ...
 **************************************************/
 
SoftTimer nextStateTimer; //millisecond timer

const int STATE_IDLE = 0;
const int STATE_LISTENING = 1;
const int STATE_SYNCHRONIZING = 2;
const int STATE_UPDATING = 3;

int state = STATE_IDLE;

void setup() {
  Serial.begin(115200);
  
  //update timers
  nextStateTimer.setTimeOutTime(1000); // IDLE, 1 second.

  //start counting now
  nextStateTimer.reset();
}

void loop() {
  //show current state
  switch(state)
  {
  case STATE_IDLE:
    Serial.println("IDLE");
    break;
  case STATE_LISTENING:
    Serial.println("LISTENING");
    break;
  case STATE_SYNCHRONIZING:
    Serial.println("SYNCHRONIZING");
    break;
  case STATE_UPDATING:
    Serial.println("UPDATING");
    break;
  default:
    Serial.println("UNKNOWN STATE!");
    break;
  };

  //look for next state...
  if (nextStateTimer.hasTimedOut())
  {
    state++;

    //limit state to known states
    state = state%(STATE_UPDATING+1);

    //reconfugure time based on new state
    switch(state)
    {
    case STATE_IDLE:
      nextStateTimer.setTimeOutTime(1000);
      break;
    case STATE_LISTENING:
      nextStateTimer.setTimeOutTime(200);
      break;
    case STATE_SYNCHRONIZING:
      nextStateTimer.setTimeOutTime(500);
      break;
    case STATE_UPDATING:
      nextStateTimer.setTimeOutTime(300);
      break;
    default:
      Serial.println("UNKNOWN STATE!");
      break;
    };

    //start counting now
    nextStateTimer.reset();
  }

  //hypothetical work...
  //processState()
}

