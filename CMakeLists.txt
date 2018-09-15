cmake_minimum_required(VERSION 3.4.3)
project(SoftTimers)

# Set the output folder where your program will be created
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(   LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

##############################################################################################################################################
# Dependencies
##############################################################################################################################################
find_package(GTest REQUIRED)
find_package(rapidassist 0.4.0 REQUIRED)
find_package(win32arduino 2.3.0 REQUIRED)


##############################################################################################################################################
# Project settings
##############################################################################################################################################

# Prevents annoying warnings on MSVC
if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

# Find all library source and unit test files
file( GLOB ARDUINO_LIBRARY_SOURCE_FILES ${PROJECT_SOURCE_DIR}/src/*.cpp   ${PROJECT_SOURCE_DIR}/src/*.h )
file( GLOB ARDUINO_LIBRARY_TEST_FILES   ${PROJECT_SOURCE_DIR}/test/*.cpp  ${PROJECT_SOURCE_DIR}/test/*.h )

# Create unit test executable
add_executable(softtimers_unittest
  ${ARDUINO_LIBRARY_SOURCE_FILES}
  ${ARDUINO_LIBRARY_TEST_FILES}
)

#include directories
target_include_directories(softtimers_unittest
  PRIVATE ${PROJECT_SOURCE_DIR}/src       # Arduino Library folder
  ${GTEST_INCLUDE_DIR}
  win32arduino
)

# Unit test projects requires to link with pthread if also linking with gtest
if(NOT WIN32)
  set(PTHREAD_LIBRARIES -pthread)
endif()

#link libraries
target_link_libraries(softtimers_unittest PRIVATE win32arduino rapidassist ${PTHREAD_LIBRARIES} ${GTEST_LIBRARIES} )
