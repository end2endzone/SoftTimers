cmake_minimum_required(VERSION 3.4.3)
project(FadeLed)

# Set the output folder where your program will be created
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(   LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

MESSAGE( STATUS "Adding example project : " ${PROJECT_NAME} )

# Validate mandatory environment variables.
if(NOT EXISTS "$ENV{WIN32ARDUINO_HOME}")
  message(FATAL_ERROR "Could not find WIN32ARDUINO_HOME environment variable")
endif()

include_directories($ENV{WIN32ARDUINO_HOME}/include)
link_directories($ENV{WIN32ARDUINO_HOME}/build/bin)

include_directories(${CMAKE_SOURCE_DIR}/src)

add_executable(FadeLed main.cpp )

if (WIN32)
  add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()

target_link_libraries(FadeLed debug     softtimers win32Arduino rapidassist)
target_link_libraries(FadeLed optimized softtimers win32Arduino rapidassist)
