add_library(win32Arduino STATIC 
  arduino.cpp
  arduino.h
  IncrementalClockStrategy.cpp
  IncrementalClockStrategy.h
  IClockStrategy.h
  RealtimeClockStrategy.cpp
  RealtimeClockStrategy.h
  SerialPrinter.cpp
  SerialPrinter.h
  stringfunc.cpp
  stringfunc.h )

include_directories(${CMAKE_SOURCE_DIR}/common)
link_directories(${LIBRARY_OUTPUT_PATH})

if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()
