# Installing

The library is deployed as zip file. Download the file from  ICI ICI IC ICIICI ICI IC ICIICI ICI IC ICIICI ICI IC ICIICI ICI IC ICI

https://www.arduino.cc/en/Guide/Libraries#toc4


# Building (SoftTimers)

This section explains how to compile and build the software on the windows platform.

## Prerequisites

The following software must be installed on the system for compiling source code:

* Visual Studio 2010 (or newer)
* [Google C++ Testing Framework v1.6.0](https://github.com/google/googletest/tree/release-1.6.0) (untested with other versions)
* [CMake](http://www.cmake.org/) v3.9.6 (or newer)
* [win32Arduino](https://github.com/end2endzone/win32Arduino/tags) v1.4.0.12 (untested with other versions)

The following software must be installed on the system for building the deploy packages:

* [7-Zip](http://www.7-zip.org/) v9.20 (or newwer) for building the library package.

## Build steps

### Google C++ testing framework

1) Download googletest source code as a [zip file](https://github.com/google/googletest/archive/release-1.6.0.zip) and extract to a temporary directory (for example c:\projects\third_party\googletest).

2) Generate googletest Visual Studio 2010 solution using cmake. Enter the following commands:
   * cd c:\projects\third_party\googletest
   * mkdir build
   * cd build
   * cmake -G "Visual Studio 10 2010" -Dgtest_force_shared_crt=ON -DCMAKE_CXX_FLAGS_DEBUG=/MDd -DCMAKE_CXX_FLAGS_RELEASE=/MD "c:\projects\third_party\googletest"

3) Open the generated Visual Studio 2010 solution file located in 
   ***c:\projects\third_party\googletest\build\gtest.sln***

4) Build the solution.

#### Define environment variables:
Note: this step need to be executed once.

Other projects needs to know where the googletest library files are located (debug & release).
Define the following environement variables:

| Name                     | Value                                        |
|--------------------------|----------------------------------------------|
|  GTEST_DEBUG_LIBRARIES   | gtest.lib                                    |
|  GTEST_RELEASE_LIBRARIES | gtest.lib                                    |
|  GOOGLETEST_HOME         | c:\projects\third_party\googletest           |
|  GTEST_INCLUDE           | c:\projects\third_party\googletest\include   |
|  GTEST_LIBRARY_DIR       | c:\projects\third_party\googletest\build     |
 
### win32Arduino

1) Download the [win32Arduino source code](https://github.com/end2endzone/win32Arduino/tags) and extract the content to a temporary directory (for example c:\projects\third_party\win32Arduino).

2) Follow build instructions in c:\projects\third_party\win32Arduino\INSTALL.md file.

3) Build the solution.

#### Define environment variables:
Note: this step need to be executed once.

Other projects needs to know where the win32Arduino library files are located (debug & release).
Define the following environement variables:

| Name                     | Value                                        |
|--------------------------|----------------------------------------------|
|  WIN32ARDUINO_HOME       | c:\projects\third_party\win32Arduino         |

### Deploy packages

The library is deployed as a zip package.

To manually build the installer packages execute the following steps:

1) Open the Visual Studio 2010 solution file located in 
   ***c:\projects\win32Arduino\msvc\win32Arduino.sln***

2) Build the solution in '*Release*' configuration.

3) Nagivate to the '*nsis*' folder.

4) Run '*build_portable.bat*' to build the portable installer or
   run '*build_setup.bat*' to build the setup installer.

5) The packages will be generated in the '*nsis/bin*' folder.
