// main.cpp : Defines the entry point for the console application.
//

#include <stdio.h>

#include <gtest/gtest.h>

#include "rapidassist/gtesthelp.h"

int main(int argc, char **argv)
{
  //define default values for xml output report
  if (ra::gtesthelp::isDebugCode())
    ::testing::GTEST_FLAG(output) = "xml:softtimers_unittest.debug.xml";
  else
    ::testing::GTEST_FLAG(output) = "xml:softtimers_unittest.release.xml";

  ::testing::GTEST_FLAG(filter) = "*";
  ::testing::InitGoogleTest(&argc, argv);

  int wResult = RUN_ALL_TESTS(); //Find and run all tests

  return wResult; // returns 0 if all the tests are successful, or 1 otherwise
}
