#include "arduino.h"

//include arduino source code
#include "ToggleLedAdvanced.ino"

int main(int argc, char* argv[])
{
  setup();
  loop(); //loop only once, not infinitely

  return 0;
}
