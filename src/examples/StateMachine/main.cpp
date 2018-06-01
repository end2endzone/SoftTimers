#include "arduino.h"

//include arduino source code
#include "StateMachine.ino"

int main(int argc, char* argv[])
{
  setup();
  loop(); //loop only once, not infinitely

  return 0;
}
