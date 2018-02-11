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
  mTimeOutTime = (uint32_t)0xFFFFFFFF; //maximum, never times out
  mCntFuncPtr = &millis;
  reset();
}

SoftTimer::SoftTimer(CounterFunctionPointer iCntFuncPtr)
{
  mTimeOutTime = (uint32_t)0xFFFFFFFF; //maximum
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

uint32_t SoftTimer::getElapsedTime()
{
  //note: this code is actually wrap around safe.
  //tested on windows platform and Arduino Nano v3.
  uint32_t now = mCntFuncPtr();
  uint32_t elapsedTime = now - mStartTime;
  return elapsedTime;
}

uint32_t SoftTimer::getRemainingTime()
{
  //note: this code is actually wrap around safe.
  //tested on windows platform and Arduino Nano v3.
  uint32_t now = mCntFuncPtr();
  uint32_t elapsedTime = now - mStartTime;
  if (elapsedTime > mTimeOutTime)
    return 0;
  uint32_t remaining = mTimeOutTime - elapsedTime;
  return remaining;
}

void SoftTimer::setTimeOutTime(uint32_t iTimeOutTime)
{
  mTimeOutTime = iTimeOutTime;
}

uint32_t SoftTimer::getTimeOutTime()
{
  return mTimeOutTime;
}

bool SoftTimer::hasTimedOut()
{
  //update time value
  uint32_t elapsedTime = getElapsedTime();
  if (elapsedTime >= mTimeOutTime)
    return true;
  return false;
}

double SoftTimer::getProgress()
{
  uint32_t elapsed = getElapsedTime();

  //warning: elapsed time can actually be greater than time out time.
  if (elapsed >= mTimeOutTime)
    return 1.0;

  //when elapsed is < than time out time.
  return double(elapsed)/double(mTimeOutTime);
}

uint32_t SoftTimer::getLoopCount()
{
  uint32_t elapsed = getElapsedTime();

  if (elapsed == 0)
    return 0;

  //note that elapsed time is decreased of 1 unit
  //this allows to have a count of 0 when exactly 
  //timing out.
  uint32_t count = (elapsed-1)/mTimeOutTime;
  return count;
}

double SoftTimer::getLoopProgress()
{
  uint32_t elapsed = getElapsedTime();
  uint32_t progress = elapsed % (mTimeOutTime);
  return double(progress)/double(mTimeOutTime);
}
