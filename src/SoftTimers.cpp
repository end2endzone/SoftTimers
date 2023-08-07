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
  mTimeOutTime = (uint32_t)(-1); //maximum value
  mCntFuncPtr = &millis;
  reset();
}

SoftTimer::SoftTimer(CounterFunctionPointer iCntFuncPtr)
{
  mTimeOutTime = (uint32_t)(-1); //maximum value
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
  uint32_t now = (uint32_t)mCntFuncPtr();
  uint32_t elapsedTime = now - mStartTime;
  return (unsigned long)elapsedTime;
}

unsigned long SoftTimer::getRemainingTime()
{
  //note: this code is actually wrap around safe.
  //tested on windows platform and Arduino Nano v3.
  uint32_t now = (uint32_t)mCntFuncPtr();
  uint32_t elapsedTime = now - mStartTime;
  if (elapsedTime > mTimeOutTime)
    return 0;
  uint32_t remaining = mTimeOutTime - elapsedTime;
  return (unsigned long)remaining;
}

void SoftTimer::setTimeOutTime(unsigned long iTimeOutTime)
{
  mTimeOutTime = (uint32_t)iTimeOutTime;
}

unsigned long SoftTimer::getTimeOutTime()
{
  return mTimeOutTime;
}

bool SoftTimer::hasTimedOut()
{
  //update time value
  uint32_t elapsedTime = (uint32_t)getElapsedTime();
  if (elapsedTime >= mTimeOutTime)
    return true;
  return false;
}

double SoftTimer::getProgress()
{
  uint32_t elapsed = (uint32_t)getElapsedTime();

  //warning: elapsed time can actually be greater than time out time.
  if (elapsed >= mTimeOutTime)
    return 1.0;

  //when elapsed is < than time out time.
  return double(elapsed)/double(mTimeOutTime);
}

unsigned long SoftTimer::getLoopCount()
{
  uint32_t elapsed = (uint32_t)getElapsedTime();

  if (elapsed == 0)
    return 0;

  //note that elapsed time is decreased of 1 unit
  //this allows to have a count of 0 when exactly 
  //timing out.
  uint32_t count = (elapsed-1)/mTimeOutTime;
  return (unsigned long)count;
}

double SoftTimer::getLoopProgress()
{
  uint32_t elapsed = (uint32_t)getElapsedTime();
  uint32_t progress = elapsed % (mTimeOutTime);
  return double(progress)/double(mTimeOutTime);
}





SoftTimerProfiler::SoftTimerProfiler() :
  timer(&micros)
{
  reset();
}

SoftTimerProfiler::SoftTimerProfiler(SoftTimer::CounterFunctionPointer iCntFuncPtr) :
  timer(iCntFuncPtr)
{
  reset();
}

SoftTimerProfiler::~SoftTimerProfiler()
{
}

void SoftTimerProfiler::reset()
{
  memset(&stats, 0, sizeof(stats));
  stats.min_time = -1;
}

void SoftTimerProfiler::start()
{
  timer.reset();
}

void SoftTimerProfiler::stop()
{
  stats.count++;
  uint32_t elapsed = timer.getElapsedTime();
  stats.total += elapsed;
  if (elapsed > stats.max_time)
    stats.max_time = elapsed;
  if (elapsed < stats.min_time)
    stats.min_time = elapsed;
}

void SoftTimerProfiler::end()
{
  stats.avg_time = float(stats.total) / float(stats.count);
}

const SoftTimerProfiler::Statistics & SoftTimerProfiler::getStatistics() const
{
  return stats;
}

void SoftTimerProfiler::print() const
{
  print("SoftTimerProfiler");
}

void SoftTimerProfiler::print(const char * name) const
{
  if (name) {
    Serial.print(name);
    Serial.println(" {");
  }
  else
    Serial.println("{");
  Serial.print("  count:"); Serial.println(stats.count);
  Serial.print("  total:"); Serial.println(stats.total);
  Serial.print("  avg:  "); Serial.println(stats.avg_time);
  Serial.print("  min:  "); Serial.println(stats.min_time);
  Serial.print("  max:  "); Serial.println(stats.max_time);
  Serial.println("}");
}
