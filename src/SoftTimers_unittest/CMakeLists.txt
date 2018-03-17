include_directories(${CMAKE_SOURCE_DIR}/SoftTimers)
link_directories(${LIBRARY_OUTPUT_PATH})

include_directories($ENV{WIN32ARDUINO_HOME}/src/win32Arduino)
link_directories($ENV{WIN32ARDUINO_HOME}/cmake/build/bin)

include_directories($ENV{GTEST_INCLUDE})
link_directories($ENV{GTEST_LIBRARY_DIR})

add_executable(softtimers_unittest
  gtesthelper.cpp
  gtesthelper.h
  main.cpp
  TestSoftTimers.cpp
  TestSoftTimers.h
)

if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

target_link_libraries(softtimers_unittest debug     softtimers.lib win32Arduino.lib gtest.lib)
target_link_libraries(softtimers_unittest optimized softtimers.lib win32Arduino.lib gtest.lib)
