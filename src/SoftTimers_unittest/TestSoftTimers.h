#pragma once

#include <gtest/gtest.h>

namespace arduino { namespace test
{
  class TestSoftTimers : public ::testing::Test
  {
  public:
    virtual void SetUp();
    virtual void TearDown();
  };

} // End namespace test
} // End namespace arduino
