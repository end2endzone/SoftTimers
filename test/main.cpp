// main.cpp : Defines the entry point for the console application.
//

#include <stdio.h>

#include <gtest/gtest.h>

#include "rapidassist/gtesthelp.h"

int main(int argc, char **argv)
{
  //define default values for xml output report
  if (ra::gtesthelp::isProcessorX86())
  {
    if (ra::gtesthelp::isDebugCode())
      ::testing::GTEST_FLAG(output) = "xml:SoftTimers_unittest.x86.debug.xml";
    else
      ::testing::GTEST_FLAG(output) = "xml:SoftTimers_unittest.x86.release.xml";
  }
  else if (ra::gtesthelp::isProcessorX64())
  {
    if (ra::gtesthelp::isDebugCode())
      ::testing::GTEST_FLAG(output) = "xml:SoftTimers_unittest.x64.debug.xml";
    else
      ::testing::GTEST_FLAG(output) = "xml:SoftTimers_unittest.x64.release.xml";
  }

  ::testing::GTEST_FLAG(filter) = "*";
  ::testing::InitGoogleTest(&argc, argv);

  int wResult = RUN_ALL_TESTS(); //Find and run all tests

  return wResult; // returns 0 if all the tests are successful, or 1 otherwise
}
