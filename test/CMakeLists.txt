include_directories(${CMAKE_SOURCE_DIR}/src)
link_directories(${LIBRARY_OUTPUT_PATH})

include_directories($ENV{WIN32ARDUINO_HOME}/include)
link_directories($ENV{WIN32ARDUINO_HOME}/build/bin)

include_directories($ENV{RAPIDASSIST_HOME}/include)
link_directories($ENV{RAPIDASSIST_HOME}/build/bin)

include_directories($ENV{GOOGLETEST_HOME}/include)
link_directories($ENV{GOOGLETEST_HOME}/build)

add_executable(softtimers_unittest
  main.cpp
  TestSoftTimers.cpp
  TestSoftTimers.h
)

if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

target_link_libraries(softtimers_unittest debug     softtimers win32Arduino gtest)
target_link_libraries(softtimers_unittest optimized softtimers win32Arduino gtest)
