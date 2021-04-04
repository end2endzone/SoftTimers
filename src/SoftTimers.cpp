// ---------------------------------------------------------------------------
// AUTHOR/LICENSE:
//  The following code was written by Antoine Beauchamp. For other authors, see AUTHORS file.
//  The code & updates for the library can be found at https://github.com/end2endzone/SoftTimers
//  MIT License: http://www.opensource.org/licenses/mit-license.php
// ---------------------------------------------------------------------------

#include "Arduino.h"
#include "SoftTimers.h"

SoftTimer::SoftTimer()
{
  mTimeOutTime = (unsigned long)0xFFFFFFFF; //maximum, never times out
  mCntFuncPtr = &millis;
  reset();
}

SoftTimer::SoftTimer(CounterFunctionPointer iCntFuncPtr)
{
  mTimeOutTime = (unsigned long)0xFFFFFFFF; //maximum
  mCntFuncPtr = iCntFuncPtr;
  reset();
}

SoftTimer::~SoftTimer()
{
}

void SoftTimer::reset()
{
  mStartTime = mCntFuncPtr();
}

unsigned long SoftTimer::getElapsedTime()
{
  //note: this code is actually wrap around safe.
  //tested on windows platform and Arduino Nano v3.
  unsigned long now = mCntFuncPtr();
  unsigned long elapsedTime = now - mStartTime;
  return elapsedTime;
}

unsigned long SoftTimer::getRemainingTime()
{
  //note: this code is actually wrap around safe.
  //tested on windows platform and Arduino Nano v3.
  unsigned long now = mCntFuncPtr();
  unsigned long elapsedTime = now - mStartTime;
  if (elapsedTime > mTimeOutTime)
    return 0;
  unsigned long remaining = mTimeOutTime - elapsedTime;
  return remaining;
}

void SoftTimer::setTimeOutTime(unsigned long iTimeOutTime)
{
  mTimeOutTime = iTimeOutTime;
}

unsigned long SoftTimer::getTimeOutTime()
{
  return mTimeOutTime;
}

bool SoftTimer::hasTimedOut()
{
  //update time value
  unsigned long elapsedTime = getElapsedTime();
  if (elapsedTime >= mTimeOutTime)
    return true;
  return false;
}

double SoftTimer::getProgress()
{
  unsigned long elapsed = getElapsedTime();

  //warning: elapsed time can actually be greater than time out time.
  if (elapsed >= mTimeOutTime)
    return 1.0;

  //when elapsed is < than time out time.
  return double(elapsed)/double(mTimeOutTime);
}

unsigned long SoftTimer::getLoopCount()
{
  unsigned long elapsed = getElapsedTime();

  if (elapsed == 0)
    return 0;

  //note that elapsed time is decreased of 1 unit
  //this allows to have a count of 0 when exactly 
  //timing out.
  unsigned long count = (elapsed-1)/mTimeOutTime;
  return count;
}

double SoftTimer::getLoopProgress()
{
  unsigned long elapsed = getElapsedTime();
  unsigned long progress = elapsed % (mTimeOutTime);
  return double(progress)/double(mTimeOutTime);
}
