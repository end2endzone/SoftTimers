include_directories($ENV{WIN32ARDUINO_HOME}/include)
link_directories($ENV{WIN32ARDUINO_HOME}/build/bin)

add_library(softtimers STATIC 
  SoftTimers.cpp
  SoftTimers.h
  SoftTimers_version.h
)

if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()
