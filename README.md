
![SoftTimers logo](https://github.com/end2endzone/SoftTimers/raw/master/docs/SoftTimers-splashscreen.png)


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Github Releases](https://img.shields.io/github/release/end2endzone/SoftTimers.svg)](https://github.com/end2endzone/SoftTimers/releases)



# SoftTimers #

The SoftTimers arduino library is a collection of software timers. It allows one to properly time multiple events and know when each "timer" expires meaning that an action is required. SoftTimers can also be used to compute the elapsed time since an event occured. The library aims at greatly simplifying multitask complexity.

Library features:
*  Provides the non-blocking equivalent to `delay()` function.
*  Each timers encapsulate its own expiration (timeout) time.
*  Provides elapsed time, remaining time and progress (in percentage) APIs.
*  Supports milliseconds, microseconds or any other arbitrary time with external time counting function.
*  Provides expiration loop count API (as if timer never expire and automatically `reset()`) to easily implement toggling, and time based state machines.
*  Automatically handles `micros()` and `millis()` overflows / wrap around special cases.
*  Provides multitasking abilities to sketches.



## Status ##

Build:

| Service/Platform    | Build                                                                                                                                                                                           | Tests                                                                                                                                                                                                                                                          |
|---------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| AppVeyor            | [![Build status](https://img.shields.io/appveyor/ci/end2endzone/SoftTimers/master.svg?logo=AppVeyor&logoColor=white)](https://ci.appveyor.com/project/end2endzone/SoftTimers)                 | [![Tests status](https://img.shields.io/appveyor/tests/end2endzone/SoftTimers/master.svg?logo=AppVeyor&logoColor=white)](https://ci.appveyor.com/project/end2endzone/SoftTimers/branch/master/tests)                                                         |
| Windows Server 2019 | [![Build on Windows](https://github.com/end2endzone/SoftTimers/actions/workflows/build_windows.yml/badge.svg)](https://github.com/end2endzone/SoftTimers/actions/workflows/build_windows.yml) | [![Tests on Windows](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/end2endzone/58cf6c72c08e706335337d5ef9ca48e8/raw/SoftTimers.master.Windows.json)](https://github.com/end2endzone/SoftTimers/actions/workflows/build_windows.yml) |
| Ubuntu 22.04        | [![Build on Linux](https://github.com/end2endzone/SoftTimers/actions/workflows/build_linux.yml/badge.svg)](https://github.com/end2endzone/SoftTimers/actions/workflows/build_linux.yml)       | [![Tests on Linux](https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/end2endzone/58cf6c72c08e706335337d5ef9ca48e8/raw/SoftTimers.master.Linux.json)](https://github.com/end2endzone/SoftTimers/actions/workflows/build_linux.yml)       |

Statistics:

| AppVeyor                                                                                                                                             | GitHub                                                                                                                          |
|------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| [![Statistics](https://buildstats.info/appveyor/chart/end2endzone/SoftTimers)](https://ci.appveyor.com/project/end2endzone/SoftTimers/branch/master) | [![Statistics](https://buildstats.info/github/chart/end2endzone/SoftTimers)](https://github.com/end2endzone/SoftTimers/actions) |




# Purpose #

Consider the arduino [Blick](https://www.arduino.cc/en/tutorial/blink) tutorial. It uses the `delay()` function to know when to toggle a LED on and off. This approach is bad since it breaks the "realtime" property of the software to react to other event. If I want to make the LED instantly turn off when pressing a button, I had to wait for the delay to complete before processing the button.

Another issue is extensibility. Making 3 LEDs blink at different time interval is much harder with delays. How about 40 LEDs? Impossible?

The SoftTimers allows one to properly time multiple events and know when each "timer" expires meaning that an action is required. In this example above, a SoftTimer expires when it is time to toggle a LED.

SoftTimers also provide the elapsed time since an event occurred. In case of an interruption, the elapsed time can be used as debugging information. It can also be used as a countdown information displayed to the user.

The library regroups basic timer functionalities into a single class. The usual way to get the same functionality is to create multiple variables for each single timer. This method is hard to maintain when you need multiple timers to run at the same time.

SoftTimer classes are designed to be keep "simple and stupid". No software interrupts. Non-blocking. Each timer must be polled within the loop() to know their status.




# Usage #

The following instructions show how to use the library.



## General ##

To use a SoftTimers, create a variable of type SoftTimer in the global scope of the program.

```cpp
SoftTimer myRefreshTimer;
```

In `setup()`, call `setTimeOutTime()` to setup the non-blocking SoftTimer then call `reset()` to initialize the internal counter.

```cpp
void setup() {
  myRefreshTimer.setTimeOutTime(30000); // every 30 seconds.
  myRefreshTimer.reset();
}
```

Within the `loop()`, call `hasTimedOut()` to know if the timer has expired. 

```cpp
void loop() {
  if (myRefreshTimer.hasTimedOut())
  {
    //TODO: refresh the input pins
    
    myRefreshTimer.reset(); //next refresh in 30 seconds
  }
}
```

At any moment, call `getElapsedTime()` or `getRemainingTime()` to get the absolute elapsed/remaining time since the last `reset()`.

```cpp
void loop() {
  if (!myRefreshTimer.hasTimedOut())
  {
    static uint32_t count = 0;
    count++;
    if (count == 1000) //print remaining time 1/1000 of loops
    {
      //show user how much time left in milliseconds
      uint32_t remaining = countdown.getRemainingTime();
      Serial.print(remaining);
      Serial.println(" ms...");
    }
  }
}
```



## Fade a LED ##

Fading a LED like in arduino's [Fade Example](https://www.arduino.cc/en/Tutorial/Fade) is trivial using SoftTimers. The library helps in defining the constant speed at which the LED will fade by defining the total length of the process and by easily mapping the timer "progress" to the amount of fade (PWM) used with the output pin. All of this in a non-blocking manner.

The following example increases the intensity of a LED from OFF to ON in 1 second and then decreases the intensity of the LED back to OFF in 1 second.

```cpp
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
```



## Countdown or Elapsed time ##

Any program that need to display a countdown or compute the elapsed time between two events can also benefit from SoftTimers.

The following example runs a countdown of 5 seconds and then turns a LED on.

```cpp
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
```



## Timed repetitive cycles ##

SoftTimer library also help reducing repetitive timed cycles to their simplest non-blocking form. SoftTimer library automatically computes current cycle index. Any toggling or cycle scenarios can be implemented with very few lines of code.

The following example implements a system where a single HIGH pin must be cycled every second within multiple pins as defined by the following loop:

* set pin 8, 9 and 13 to LOW, LOW and HIGH respectively and then wait 1 second.
* set pin 8, 9 and 13 to HIGH, LOW and LOW respectively and then wait 1 second.
* set pin 8, 9 and 13 to LOW, HIGH and LOW respectively and then wait 1 second.
* repeat the cycle forever...

```cpp
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
```



## Timed restricted state machines ##

SoftTimer library allows one to make an easy abstraction of time when dealing with timed restricted state machines.

The following example implement an hypothetical state machine where each state has a maximum duration:

* State #1 – IDLE (1000 ms)
* State #2 – LISTENING (200 ms)
* State #3 – SYNCHRONIZING (500 ms)
* State #4 – UPDATING (300 ms)
* State #1 ...

```cpp
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
```



## Compute performance of a function or a section of code (a.k.a profiling) ##

SoftTimer library allows one to easily compute the performance of a function or a section of code.

This feature is usefull for debugging. For example, it can be used to identify a section of code or an algorithm that needs to be optimized.

It is particuly usefull with microcontrollers that are equiped with a [Watchdog Timer](https://en.wikipedia.org/wiki/Watchdog_timer) that resets the microcontroller if the `loop()` function appears to be blocking. The profiling classes `SoftTimerProfiler`, `SoftTimerProfilerMillis` and `SoftTimerProfilerMicros` provides an easy way to identify "blocking" sections of code that needs to be re-written in a non-blocking way.

The following example uses a `SoftTimerProfiler` to compute the average time of the following:
* The function `analogRead()` with microseconds resolution. 
* An implementation of _Bubble Sort_ algorithm with milliseconds resolution.

```cpp
#include <SoftTimers.h>

#define ANALOG_PIN A0

/****************************************************************
 * Compute the minimum, maximum and average time of a function or
 * a section of code to execute.
 ****************************************************************/

int loop_count = 0;

static const int unsorted_values[] PROGMEM = {
179, 211, 219, 307, 495, 462, 485, 396, 286, 189, 361, 122, 312, 398, 218, 487, 287, 452, 86, 297, 147, 196, 298, 158, 265, 136, 229, 301, 412, 160, 300,
168, 489, 407, 34, 303, 443, 2, 149, 391, 131, 228, 360, 128, 343, 271, 294, 186, 69, 267, 164, 10, 340, 223, 63, 140, 132, 508, 258, 496, 457, 266, 44,
43, 115, 313, 447, 57, 247, 123, 296, 7, 499, 399, 112, 198, 126, 374, 213, 163, 220, 335, 474, 473, 451, 161, 420, 475, 18, 37, 212, 104, 144, 245, 28,
410, 143, 60, 446, 356, 127, 162, 224, 365, 510, 170, 109, 54, 137, 392, 155, 16, 330, 389, 302, 225, 467, 89, 153, 317, 275, 436, 184, 107, 388, 56, 230,
319, 270, 174, 488, 156, 280, 347, 30, 497, 148, 409, 38, 8, 454, 382, 427, 358, 461, 441, 274, 251, 135, 181, 440, 387, 263, 23, 311, 422, 426, 509, 468,
345, 173, 460, 90, 76, 39, 332, 385, 1, 484, 432, 419, 310, 64, 53, 390, 242, 222, 491, 324, 221, 283, 444, 237, 350, 134, 70, 45, 470, 395, 171, 29, 48,
209, 116, 429, 207, 438, 273, 328, 289, 423, 479, 459, 210, 430, 252, 259, 11, 167, 406, 185, 244, 142, 425, 35, 25, 450, 206, 78, 367, 12, 238, 309, 77,
264, 133, 415, 85, 208, 66, 493, 9, 180, 404, 351, 187, 483, 49, 91, 32, 166, 339, 394, 130, 94, 333, 243, 169, 58, 241, 165, 232, 22, 299, 276, 393, 82,
354, 103, 192, 88, 418, 84, 5, 119, 500, 6, 42, 190, 59, 341, 414, 110, 379, 463, 282, 151, 195, 480, 503, 150, 348, 377, 239, 346, 75, 19, 372, 3, 125,
417, 413, 323, 336, 506, 73, 261, 424, 95, 256, 15, 408, 201, 98, 233, 384, 327, 355, 260, 124, 14, 284, 326, 46, 17, 191, 72, 79, 363, 397, 51, 511, 437,
453, 386, 472, 102, 501, 357, 93, 215, 369, 183, 117, 177, 269, 381, 492, 308, 154, 456, 486, 305, 466, 316, 105, 272, 13, 67, 254, 157, 315, 121, 108,
375, 442, 203, 97, 338, 400, 376, 52, 36, 33, 490, 290, 27, 20, 113, 494, 26, 81, 4, 321, 401, 325, 47, 65, 458, 295, 481, 74, 465, 250, 193, 50, 279, 24,
380, 433, 235, 383, 285, 364, 306, 145, 505, 362, 507, 448, 268, 434, 111, 202, 138, 370, 322, 455, 236, 101, 471, 139, 129, 405, 334, 234, 291, 141, 371,
342, 159, 477, 99, 329, 314, 359, 21, 100, 257, 172, 352, 318, 320, 199, 176, 61, 246, 204, 240, 504, 502, 214, 416, 41, 449, 227, 178, 293, 92, 366, 182,
435, 253, 469, 331, 118, 96, 152, 55, 402, 498, 194, 445, 248, 353, 205, 421, 231, 226, 431, 344, 114, 277, 31, 464, 278, 216, 262, 40, 80, 106, 120, 68,
439, 476, 304, 87, 71, 175, 403, 349, 146, 83, 249, 373, 197, 288, 411, 428, 200, 281, 378, 292, 62, 368, 188, 337, 255, 217, 482, 478,};
static const size_t unsorted_values_count = sizeof(unsorted_values) / sizeof(unsorted_values[0]);
static const size_t sorted_values_count = unsorted_values_count;
static int sorted_values[sorted_values_count];

void setup() {
  pinMode(ANALOG_PIN, INPUT);

  Serial.begin(115200);
  Serial.println("ready");
}

void profileAnalogRead() {
  SoftTimerProfiler profiler(&micros); // microseconds profiler
  profiler.reset();

  for(int i=0; i<1000; i++) {
    profiler.start();
    int value = analogRead(ANALOG_PIN);
    profiler.stop();
  }

  profiler.end();
  profiler.print("analogRead");
}

void printArray(int array[], size_t count) {
  Serial.println("<values>");
  for(size_t i=0; i<count; i++) {
    Serial.print(array[i]);
    bool is_last = !(i+1<count);
    if (!is_last)
      Serial.print(", ");
  }
  Serial.println();
  Serial.println("</values>");
}

// perform the bubble sort
void bubbleSort(int array[], int size) {

  // loop to access each array element
  for (int step = 0; step < size - 1; ++step) {
      
    // loop to compare array elements
    for (int i = 0; i < size - step - 1; ++i) {
      
      // compare two adjacent elements
      // change > to < to sort in descending order
      if (array[i] > array[i + 1]) {
        
        // swapping occurs if elements
        // are not in the intended order
        int temp = array[i];
        array[i] = array[i + 1];
        array[i + 1] = temp;
      }
    }
  }
}

void profileBubbleSort() {
  SoftTimerProfilerMillis profiler; // milliseconds profiler
  profiler.reset();

  for(int i=0; i<50; i++) {
    // Copy unsorted values into the array that we will sort.
    // This operation is outside of the scope of the profiler.
    memcpy_P(&sorted_values, unsorted_values, sizeof(sorted_values));
    //printArray(sorted_values, sorted_values_count);

    profiler.start();
    bubbleSort(sorted_values, sorted_values_count);
    profiler.stop();
  }

  profiler.end();
  profiler.print("bubbleSort");
}

void loop() {
  if (loop_count%2 == 0)
    profileAnalogRead();
  else
    profileBubbleSort();

  loop_count++;
}
```

The above sketch outputs the following to the serial port:

```
analogRead {
  count:1000
  total:97009
  avg:  97.01
  min:  94
  max:  111
}
bubbleSort {
  count:50
  total:1063
  avg:  21.26
  min:  21
  max:  22
```

On average, the function `analogRead()` executes in 97.01 microseconds. The fastest call took 94 us and a worst call took 111 us.

The _Bubble Sort_ algorithm executes on average in 21.26 milliseconds on this particular unsorted array of integers. Since the minimum and maximum times are almost identical, the algorithm does not seems to be affected by external factors.




## Other ##

More SoftTimer examples are also available:

* [Countdown](examples/Countdown/Countdown.ino)
* [CycleHighPin](examples/CycleHighPin/CycleHighPin.ino)
* [FadeLed](examples/FadeLed/FadeLed.ino)
* [LimitPrintedMessages](examples/LimitPrintedMessages/LimitPrintedMessages.ino)
* [ProfileFunctions](examples/ProfileFunctions/ProfileFunctions.ino)
* [ProgressBar](examples/ProgressBar/ProgressBar.ino)
* [StateMachine](examples/StateMachine/StateMachine.ino)
* [ToggleLed](examples/ToggleLed/ToggleLed.ino)
* [ToggleLedAdvanced](examples/ToggleLedAdvanced/ToggleLedAdvanced.ino)




# Building #

Please refer to file [INSTALL.md](INSTALL.md) for details on how installing/building the application.




# Platforms #

SoftTimers has been tested with the following platform:

  * Linux x86/x64
  * Windows x86/x64




# Versioning #

We use [Semantic Versioning 2.0.0](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/end2endzone/SoftTimers/tags).

# Authors #

* **Antoine Beauchamp** - *Initial work* - [end2endzone](https://github.com/end2endzone)

See also the list of [contributors](https://github.com/end2endzone/SoftTimers/blob/master/AUTHORS) who participated in this project.

# License #

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
