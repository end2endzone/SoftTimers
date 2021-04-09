// ---------------------------------------------------------------------------
// AUTHOR/LICENSE:
//  The following code was written by Antoine Beauchamp. For other authors, see AUTHORS file.
//  The code & updates for the library can be found at https://github.com/end2endzone/SoftTimers
//  MIT License: http://www.opensource.org/licenses/mit-license.php
// ---------------------------------------------------------------------------

#ifndef SoftTimers_h
#define SoftTimers_h

#include "Arduino.h"

class SoftTimer
{
public:
  /****************************************************************************
   * Description:
   *   Defines a generic 32 bits counting function.
   ****************************************************************************/
  typedef unsigned long (*CounterFunctionPointer)();

  /****************************************************************************
   * Description:
   *   Creates a SoftTimer instance which units is milliseconds.
   ****************************************************************************/
  SoftTimer();

  /****************************************************************************
   * Description:
   *   Creates a SoftTimer instance with custom unit.
   * Parameters:
   *   iCntFuncPtr: Pointer to a counting function.
   *                Use &millis to get a SoftTimer configured in milliseconds
   *                Use &micros to get a SoftTimer configured in microseconds
   ****************************************************************************/
  SoftTimer(CounterFunctionPointer iCntFuncPtr);

  /****************************************************************************
   * Description:
   *   Destructor
   ****************************************************************************/
  ~SoftTimer();

  /****************************************************************************
   * Description:
   *   reset() resets the internal counter of the Timer.
   ****************************************************************************/
  void reset();

  /****************************************************************************
   * Description:
   *   getElapsedTime() returns the elapsed time since the last reset()
   *   and now.
   ****************************************************************************/
  unsigned long getElapsedTime();

  /****************************************************************************
   * Description:
   *   getRemainingTime() returns the remaining time until the timer times out.
   *   Useful if one needs to show feedback to user.
   ****************************************************************************/
  unsigned long getRemainingTime();

  /****************************************************************************
   * Description:
   *   setTimeOutTime() defines the time out time at which hasTimedOut()
   *   will return true.
   * Parameters:
   *   iTimeOutTime: The given time out time in millisecond.
   ****************************************************************************/
  void setTimeOutTime(unsigned long iTimeOutTime);

  /****************************************************************************
   * Description:
   *   getTimeOutTime() returns the time out time at which hasTimedOut()
   *   will return true.
   ****************************************************************************/
  unsigned long getTimeOutTime();

  /****************************************************************************
   * Description:
   *   hasTimedOut() returns true if the elapsed time since reset() is
   *   greater or equal than the given time out time.
   ****************************************************************************/
  bool hasTimedOut();

  /****************************************************************************
   * Description:
   *   getProgress() returns the current timer progress in percentage
   *   (within [0, 1.0]) based on start time up to time out time.
   ****************************************************************************/
  double getProgress();
  
  /****************************************************************************
   * Description:
   *   getLoopProgress() returns the progress in percentage (within [0, 1.0])
   *   based on start time up to time out time as if the timer would
   *   automatically reset() when timing out.
   *   Note that a progress of 0% is the same as a progress of 100%.
   ****************************************************************************/
  double getLoopProgress();

  /****************************************************************************
   * Description:
   *   getLoopCount() returns the number of times the timer would have expired
   *   if the timer would automatically reset() when timing out.
   *   Useful for calculating pins that should toggle when timer expires.
   ****************************************************************************/
  unsigned long getLoopCount();

protected:
  CounterFunctionPointer mCntFuncPtr;
  volatile uint32_t mStartTime;
  uint32_t mTimeOutTime;
};


//define legacy classes for backward compatibility
class SoftTimerMillis : public SoftTimer
{
public:
  SoftTimerMillis() : SoftTimer(&millis)
  {
  }
  ~SoftTimerMillis() {}
};

class SoftTimerMicros : public SoftTimer
{
public:
  SoftTimerMicros() : SoftTimer(&micros)
  {
  }
  ~SoftTimerMicros() {}
};

#endif
