cmake_minimum_required(VERSION 3.4.3)
project(softtimers)

# Set the output folder where your program will be created
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)
set(   LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

MESSAGE( STATUS "CMAKE_BINARY_DIR:         " ${CMAKE_BINARY_DIR} )
MESSAGE( STATUS "CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR} )
MESSAGE( STATUS "CMAKE_SOURCE_DIR:         " ${CMAKE_SOURCE_DIR} )
MESSAGE( STATUS "CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR} )
MESSAGE( STATUS "PROJECT_BINARY_DIR:       " ${PROJECT_BINARY_DIR} )
MESSAGE( STATUS "PROJECT_SOURCE_DIR:       " ${PROJECT_SOURCE_DIR} )
MESSAGE( STATUS "EXECUTABLE_OUTPUT_PATH:   " ${EXECUTABLE_OUTPUT_PATH} )
MESSAGE( STATUS "LIBRARY_OUTPUT_PATH:      " ${LIBRARY_OUTPUT_PATH} )
MESSAGE( STATUS "CMAKE_MODULE_PATH:        " ${CMAKE_MODULE_PATH} )
MESSAGE( STATUS "CMAKE_COMMAND:            " ${CMAKE_COMMAND} )
MESSAGE( STATUS "CMAKE_ROOT:               " ${CMAKE_ROOT} )
MESSAGE( STATUS "CMAKE_CURRENT_LIST_FILE:  " ${CMAKE_CURRENT_LIST_FILE} )
MESSAGE( STATUS "CMAKE_CURRENT_LIST_LINE:  " ${CMAKE_CURRENT_LIST_LINE} )
MESSAGE( STATUS "CMAKE_INCLUDE_PATH:       " ${CMAKE_INCLUDE_PATH} )
MESSAGE( STATUS "CMAKE_LIBRARY_PATH:       " ${CMAKE_LIBRARY_PATH} )
MESSAGE( STATUS "CMAKE_SYSTEM:             " ${CMAKE_SYSTEM} )
MESSAGE( STATUS "CMAKE_SYSTEM_NAME:        " ${CMAKE_SYSTEM_NAME} )
MESSAGE( STATUS "CMAKE_SYSTEM_VERSION:     " ${CMAKE_SYSTEM_VERSION} )
MESSAGE( STATUS "CMAKE_SYSTEM_PROCESSOR:   " ${CMAKE_SYSTEM_PROCESSOR} )

#------------------------------------------------------------------------------------------------------------
# Set a default build type if none was specified.
# See https://blog.kitware.com/cmake-and-the-default-build-type/
#------------------------------------------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to 'Release' as none was specified.")
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  mark_as_advanced(CMAKE_BUILD_TYPE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

#------------------------------------------------------------------------------------------------------------
# Define product version according to Semantic Versioning v2.0.0 https://semver.org/
#------------------------------------------------------------------------------------------------------------
MESSAGE("")
SET(SOFTTIMERS_MAJOR_VERSION 1)
SET(SOFTTIMERS_MINOR_VERSION 3)
SET(SOFTTIMERS_PATCH_VERSION 0)
SET(SOFTTIMERS_PRERELEASE_VERSION "") #i.e: rc1
SET(SOFTTIMERS_METADATA_VERSION "")   #i.e: build.45
SET(SOFTTIMERS_VERSION_STRING ${SOFTTIMERS_MAJOR_VERSION}.${SOFTTIMERS_MINOR_VERSION}.${SOFTTIMERS_PATCH_VERSION})
IF(NOT ${SOFTTIMERS_PRERELEASE_VERSION} STREQUAL "")
  SET(SOFTTIMERS_VERSION_STRING ${SOFTTIMERS_VERSION_STRING}-${SOFTTIMERS_PRERELEASE_VERSION})
ENDIF()
IF(NOT ${SOFTTIMERS_METADATA_VERSION} STREQUAL "")
  SET(SOFTTIMERS_VERSION_STRING ${SOFTTIMERS_VERSION_STRING}+${SOFTTIMERS_METADATA_VERSION})
ENDIF()
MESSAGE("SOFTTIMERS_VERSION_STRING: ${SOFTTIMERS_VERSION_STRING}")
MESSAGE("")

# Generate version files for different systems
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/version.in"                       "${CMAKE_CURRENT_SOURCE_DIR}/version")
CONFIGURE_FILE("${CMAKE_CURRENT_SOURCE_DIR}/library.properties.in"            "${CMAKE_CURRENT_SOURCE_DIR}/library.properties")

#------------------------------------------------------------------------------------------------------------
# Validate mandatory environment variables.
#------------------------------------------------------------------------------------------------------------
if(NOT EXISTS "$ENV{GOOGLETEST_HOME}")
  message(FATAL_ERROR "Could not find GOOGLETEST_HOME environment variable")
endif()
if(NOT EXISTS "$ENV{RAPIDASSIST_HOME}")
  message(FATAL_ERROR "Could not find RAPIDASSIST_HOME environment variable")
endif()
if(NOT EXISTS "$ENV{WIN32ARDUINO_HOME}")
  message(FATAL_ERROR "Could not find WIN32ARDUINO_HOME environment variable")
endif()

#------------------------------------------------------------------------------------------------------------
# Add source directories
#------------------------------------------------------------------------------------------------------------
add_subdirectory(src)

#------------------------------------------------------------------------------------------------------------
# unit tests
#------------------------------------------------------------------------------------------------------------
option(SOFTTIMERS_BUILD_TEST "Build all SoftTimers tests" OFF)
if(SOFTTIMERS_BUILD_TEST)
  add_subdirectory(test)

  # googletest
  if (NOT TARGET gtest)
    if (WIN32)
      # https://stackoverflow.com/a/12546288
      # Force building googletest in `Multi-threaded Debug DLL (/MDd)` and `Multi-threaded DLL (/MD)`
      set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    endif()
    add_subdirectory($ENV{GOOGLETEST_HOME})
    set_target_properties(gtest_main PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
  endif()

  # Define project dependencies
  add_dependencies(softtimers_unittest softtimers)
  add_dependencies(softtimers_unittest gtest)
endif()

#------------------------------------------------------------------------------------------------------------
# Add dependencies
#------------------------------------------------------------------------------------------------------------
# googletest
if (NOT TARGET gtest)
  if (WIN32)
    # https://stackoverflow.com/a/12546288
    # Force building googletest in `Multi-threaded Debug DLL (/MDd)` and `Multi-threaded DLL (/MD)`
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  endif()
  add_subdirectory($ENV{GOOGLETEST_HOME})
  set_target_properties(gtest_main PROPERTIES EXCLUDE_FROM_ALL 1 EXCLUDE_FROM_DEFAULT_BUILD 1)
endif()

# win32Arduino
if (NOT TARGET win32Arduino)
  add_subdirectory($ENV{WIN32ARDUINO_HOME})
endif()
add_dependencies(softtimers win32Arduino)

#------------------------------------------------------------------------------------------------------------
# Add all examples of the library.
#------------------------------------------------------------------------------------------------------------
option(SOFTTIMERS_BUILD_EXAMPLES "Build all samples projects" OFF)
if(SOFTTIMERS_BUILD_EXAMPLES)
  add_subdirectory(examples/Countdown)
  add_subdirectory(examples/CycleHighPin)
  add_subdirectory(examples/FadeLed)
  add_subdirectory(examples/ProgressBar)
  add_subdirectory(examples/StateMachine)
  add_subdirectory(examples/ToggleLed)
  add_subdirectory(examples/ToggleLedAdvanced)
  
  add_dependencies(Countdown          win32Arduino)
  add_dependencies(CycleHighPin       win32Arduino)
  add_dependencies(FadeLed            win32Arduino)
  add_dependencies(ProgressBar        win32Arduino)
  add_dependencies(StateMachine       win32Arduino)
  add_dependencies(ToggleLed          win32Arduino)
  add_dependencies(ToggleLedAdvanced  win32Arduino)
  
  set_property(GLOBAL PROPERTY USE_FOLDERS ON)
  set_target_properties(Countdown          PROPERTIES FOLDER "SoftTimers examples")
  set_target_properties(CycleHighPin       PROPERTIES FOLDER "SoftTimers examples")
  set_target_properties(FadeLed            PROPERTIES FOLDER "SoftTimers examples")
  set_target_properties(ProgressBar        PROPERTIES FOLDER "SoftTimers examples")
  set_target_properties(StateMachine       PROPERTIES FOLDER "SoftTimers examples")
  set_target_properties(ToggleLed          PROPERTIES FOLDER "SoftTimers examples")
  set_target_properties(ToggleLedAdvanced  PROPERTIES FOLDER "SoftTimers examples")
endif()

#------------------------------------------------------------------------------------------------------------
# Generate doxygen documentation
# See https://vicrucann.github.io/tutorials/quick-cmake-doxygen/
#------------------------------------------------------------------------------------------------------------
option(SOFTTIMERS_BUILD_DOC "Build documentation" OFF)
if (SOFTTIMERS_BUILD_DOC)
  # check if Doxygen is installed
  find_package(Doxygen)
  if (DOXYGEN_FOUND)
    # set input and output files
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
 
    # request to configure the file
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
    message("Doxygen build started")
 
    # note the option ALL which allows to build the docs together with the application
    add_custom_target( softtimers_doc ALL
      COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
      COMMENT "Generating API documentation with Doxygen"
      VERBATIM )
  else (DOXYGEN_FOUND)
    message("Doxygen need to be installed to generate the doxygen documentation")
  endif (DOXYGEN_FOUND)
endif()
