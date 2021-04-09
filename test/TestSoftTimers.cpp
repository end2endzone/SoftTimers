#include <stdio.h>

#include <string>
#include "TestSoftTimers.h"
#include "Arduino.h"
#include "IncrementalClockStrategy.h"
#include "SoftTimers.h"

using namespace testarduino;

namespace arduino { namespace test
{
  IncrementalClockStrategy & gClock = IncrementalClockStrategy::getInstance();

  static const uint32_t MAX_TIME_COUNTER_VALUE = (uint32_t)(-1);
  
  static unsigned long gLocalCounter = 0;
  unsigned long getLocalCounter()
  {
    return gLocalCounter;
  }

  template<typename T>
  bool isNear(T expected, T actual, T epsilon)
  {
    T minValue = expected-epsilon;
    T maxValue = expected+epsilon;
    if (minValue <= expected && expected <= maxValue)
      return true;
    return false;
  }

  //--------------------------------------------------------------------------------------------------
  void TestSoftTimers::SetUp()
  {
    //force simulation strategy of win32Arduino library
    testarduino::setClockStrategy(&gClock);

    //disable function logging
    testarduino::setLogFile("");
  }
  //--------------------------------------------------------------------------------------------------
  void TestSoftTimers::TearDown()
  {
  }
  //--------------------------------------------------------------------------------------------------
  TEST_F(TestSoftTimers, testBasicMillis)
  {
    SoftTimerMillis t;
    
    ASSERT_LT(t.getElapsedTime(), 20); //20 ms epsilon since time can actually flows between contructor time and current time
    ASSERT_FALSE( t.hasTimedOut() );

    t.setTimeOutTime(300); //0.3 second.

    ASSERT_FALSE( t.hasTimedOut() );

    //wait for the delay to expire
    //which should expires the timer
    uint32_t now = (uint32_t)millis();
    uint32_t until = now+300;
    while(millis() < until)
    {
    }

    ASSERT_TRUE( t.hasTimedOut() );
    t.reset();
    ASSERT_FALSE( t.hasTimedOut() );
    ASSERT_LT(t.getElapsedTime(), 20); //20 ms epsilon since time can actually flows between contructor time and current time
  }
  //--------------------------------------------------------------------------------------------------
  TEST_F(TestSoftTimers, testMicrosOverflow)
  {
    SoftTimerMicros t;

    //wait for the micros() function to *almost* wrap around
    gClock.setMicrosecondsCounter(MAX_TIME_COUNTER_VALUE-0x0000FFFF);  // 65536 usec before wrapping around
    uint32_t until = (MAX_TIME_COUNTER_VALUE-0xFF); //255 usec before wrapping around
    while(micros() < until)
    {
    }

    //start counting time from here
    t.setTimeOutTime(500);
    t.reset(); //expecting start time of ~0xFFFFFF08

    ASSERT_FALSE( t.hasTimedOut() ) << "Unexpected timeout! getElapsedTime()=" << t.getElapsedTime() << ". micros()=" << micros();
    ASSERT_LT(t.getElapsedTime(), 20); //20 usec epsilon since time can actually flows between contructor time and current time

    //wait ~255 usec for the micros() function to actually wrap around
    //from ~0xFFFFFF08 to 0xFFFFFFFF
    while(micros() > 0xFFFF0000)
    {
    }

    //wait ~50 usec more (this makes the total elaped time to ~305 usec (255+50))
    until = 50; //from ~0x00000000 to more than 50 usec.
    while(micros() < until)
    {
    }

    //assert elapsed time should be close to 305 usec (255+50)
    ASSERT_FALSE( t.hasTimedOut() ) << "Unexpected timeout! getElapsedTime()=" << t.getElapsedTime() << ". micros()=" << micros();
    ASSERT_NEAR(t.getElapsedTime(), 305, 20); //allow 20 usec epsilon
    
    //wait for timer to actually time out
    uint32_t now = (uint32_t)micros();
    until = now+250; // from ~305 usec to ~555 usec
    while(micros() < until)
    {
    }
    
    ASSERT_TRUE( t.hasTimedOut() ) << "Unexpected timeout! getElapsedTime()=" << t.getElapsedTime() << ". micros()=" << micros();
    ASSERT_GT(t.getElapsedTime(), 500);
  }
  //--------------------------------------------------------------------------------------------------
  TEST_F(TestSoftTimers, testMillisConfiguration)
  {
    SoftTimer t(&millis);

    ASSERT_LT(t.getElapsedTime(), 2); //2 ms epsilon since time can actually flows between contructor time and current time
    ASSERT_FALSE( t.hasTimedOut() );

    t.setTimeOutTime(300); //300ms second.

    ASSERT_FALSE( t.hasTimedOut() );

    //wait for the delay to expire
    //which should expires the timer
    uint32_t now = (uint32_t)millis();
    uint32_t until = now+300;
    while(millis() < until)
    {
    }

    ASSERT_TRUE( t.hasTimedOut() );
    t.reset();
    ASSERT_FALSE( t.hasTimedOut() );
    ASSERT_LT(t.getElapsedTime(), 2); //2 ms epsilon since time can actually flows between contructor time and current time
  }
  //--------------------------------------------------------------------------------------------------
  TEST_F(TestSoftTimers, testProgress)
  {
    static double const PROGRESS_EPSILON = 0.0001;

    //using local counter for tests
    gLocalCounter = 0;
    SoftTimer t(&getLocalCounter);

    //using a time out of 100 unit of time
    //to expecting a progress from 0% to 100%
    //without missing/skipping any % value:
    //0%, 1%, 2%, 3%, ... 97%, 98%, 99%, 100%
    t.setTimeOutTime(100);

    //assert progress when elapsed time is 0
    gLocalCounter = 0;
    ASSERT_EQ(      0, t.getElapsedTime() );
    ASSERT_NEAR( 0.00, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_NEAR( 0.00, t.getLoopProgress(), PROGRESS_EPSILON);
    ASSERT_EQ(      0, t.getLoopCount() );
    ASSERT_FALSE( t.hasTimedOut() );

    //assert progress > 0 when 1 unit of time has elapsed
    gLocalCounter = 1;
    ASSERT_EQ(      1, t.getElapsedTime() );
    ASSERT_NEAR( 0.01, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_NEAR( 0.01, t.getLoopProgress(), PROGRESS_EPSILON );
    ASSERT_EQ(      0, t.getLoopCount() );
    ASSERT_FALSE( t.hasTimedOut() );

    //assert progress when 1 unit of time before timing out
    gLocalCounter = 99;
    ASSERT_EQ(     99, t.getElapsedTime() );
    ASSERT_NEAR( 0.99, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_NEAR( 0.99, t.getLoopProgress(), PROGRESS_EPSILON );
    ASSERT_EQ(      0, t.getLoopCount() );
    ASSERT_FALSE( t.hasTimedOut() );

    //assert progress when exactly timing out
    gLocalCounter = 100;
    ASSERT_EQ(    100, t.getElapsedTime() );
    ASSERT_NEAR( 1.00, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_TRUE( isNear(1.00, t.getLoopProgress(), PROGRESS_EPSILON) || isNear(0.00, t.getLoopProgress(), PROGRESS_EPSILON) ); //0% is the same as 100%
    ASSERT_EQ(      0, t.getLoopCount() );
    ASSERT_TRUE( t.hasTimedOut() );

    //assert progress when exactly 1 unit of time AFTER timing out
    gLocalCounter = 101;
    ASSERT_EQ(    101, t.getElapsedTime() );
    ASSERT_NEAR( 1.00, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_NEAR( 0.01, t.getLoopProgress(), PROGRESS_EPSILON );
    ASSERT_EQ(      1, t.getLoopCount() );
    ASSERT_TRUE( t.hasTimedOut() );

    //assert progress when exactly 1 unit of time BEFORE 2nd timing out
    gLocalCounter = 199;
    ASSERT_EQ(    199, t.getElapsedTime() );
    ASSERT_NEAR( 1.00, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_NEAR( 0.99, t.getLoopProgress(), PROGRESS_EPSILON );
    ASSERT_EQ(      1, t.getLoopCount() );
    ASSERT_TRUE( t.hasTimedOut() );

    //assert progress when exactly at 2nd timing out
    gLocalCounter = 200;
    ASSERT_EQ(    200, t.getElapsedTime() );
    ASSERT_NEAR( 1.00, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_TRUE( isNear(1.00, t.getLoopProgress(), PROGRESS_EPSILON) || isNear(0.00, t.getLoopProgress(), PROGRESS_EPSILON) ); //0% is the same as 100%
    ASSERT_EQ(      1, t.getLoopCount() );
    ASSERT_TRUE( t.hasTimedOut() );

    //assert progress when exactly 1 unit of time AFTER 2nd timing out
    gLocalCounter = 201;
    ASSERT_EQ(    201, t.getElapsedTime() );
    ASSERT_NEAR( 1.00, t.getProgress(), PROGRESS_EPSILON );
    ASSERT_NEAR( 0.01, t.getLoopProgress(), PROGRESS_EPSILON );
    ASSERT_EQ(      2, t.getLoopCount() );
    ASSERT_TRUE( t.hasTimedOut() );
  }
  //--------------------------------------------------------------------------------------------------
  TEST_F(TestSoftTimers, testRemainingTime)
  {
    //using local counter for tests
    gLocalCounter = 0;
    SoftTimer t(&getLocalCounter);

    t.setTimeOutTime(100);

    //assert progress when elapsed time is 0
    gLocalCounter = 0;
    ASSERT_EQ(   0, t.getElapsedTime() );
    ASSERT_EQ( 100, t.getRemainingTime() );

    //assert progress > 0 when 1 unit of time has elapsed
    gLocalCounter = 1;
    ASSERT_EQ(   1, t.getElapsedTime() );
    ASSERT_EQ(  99, t.getRemainingTime() );

    //assert progress when 1 unit of time before timing out
    gLocalCounter = 99;
    ASSERT_EQ(  99, t.getElapsedTime() );
    ASSERT_EQ(   1, t.getRemainingTime() );

    //assert progress when exactly timing out
    gLocalCounter = 100;
    ASSERT_EQ( 100, t.getElapsedTime() );
    ASSERT_EQ(   0, t.getRemainingTime() );

    //assert progress when exactly 1 unit of time AFTER timing out
    gLocalCounter = 101;
    ASSERT_EQ( 101, t.getElapsedTime() );
    ASSERT_EQ(   0, t.getRemainingTime() );

    //assert progress when exactly 2 unit of time AFTER timing out
    gLocalCounter = 102;
    ASSERT_EQ( 102, t.getElapsedTime() );
    ASSERT_EQ(   0, t.getRemainingTime() );
  }
  //--------------------------------------------------------------------------------------------------
} // End namespace test
} // End namespace arduino
