# Installing

The library does not provide an automatic installer package. It is deployed using a zip archive which only contains the source code. It can be installed on the system by following the same steps as with other Arduino library.

## Download the library .zip file

The latest version of the library can be found in the project's [release page](http://github.com/end2endzone/SoftTimers/releases/latest).

Each release of the library contains 3 files:
* The archive installer in .zip format (identified as `SoftTimers.vX.Y.Z.zip`)
* The project source code and documentation in .zip format (identified as `Source code (zip)`)
* The project source code and documentation in tar.gz (identified as `Source code (tar.gz)`)

Download the `library archive installer` from an existing tags and extract the content to a local directory (for example `c:\my_arduino_libraries`).

## Import the .zip library

The library can be installed on the system by following the same steps as other Arduino library.

Refer to the official Arduino guide on how [importing a .zip library](http://www.arduino.cc/en/Guide/Libraries#toc4) for details.

### User Error 'Zip doesn't contain a library'

When importing a library in the Arduino IDE, you may get the `Zip doesn't contain a library` error message.

This is probably because you tried to install the `project source code` instead of the `archive installer in .zip format`. Follow the instructions of the [Download](#download-the-library-zip-file) section.


# Building

The library comes with unit tests which are not compatible with the arduino development environment and must be compiled on the windows platform.

The library can be build on windows for debugging and running unit tests with the help of [win32Arduino](http://github.com/end2endzone/win32Arduino) library.

This section explains how to compile and build the software and how to get a test environment ready.

## Prerequisites

The following software must be installed on the system for compiling source code:

* Visual Studio 2010 (or newer)
* [Google C++ Testing Framework v1.6.0](https://github.com/google/googletest/tree/release-1.6.0) (untested with other versions)
* [CMake](http://www.cmake.org/) v3.9.6 (or newer)
* [win32Arduino](https://github.com/end2endzone/win32Arduino/tags) v1.4.0.12 (untested with other versions)

The following software must be installed on the system for building the deploy packages:

* ~~[7-Zip](http://www.7-zip.org/) v9.20 (or newwer) for building the library package.~~

## Build steps

### Google C++ testing framework

1) Download googletest source code as a [zip file](https://github.com/google/googletest/archive/release-1.6.0.zip) to your computer and extract to a temporary directory (for example `c:\projects\SoftTimers\third_party\googletest`).

2) Generate the Visual Studio 2010 solution using the following commands:
   * cd c:\projects\SoftTimers\third_party\googletest
   * mkdir build
   * cd build
   * cmake -G "Visual Studio 10 2010" -Dgtest_force_shared_crt=ON -DCMAKE_CXX_FLAGS_DEBUG=/MDd -DCMAKE_CXX_FLAGS_RELEASE=/MD ..

3) Open the generated Visual Studio 2010 solution file located in `c:\projects\SoftTimers\third_party\googletest\build\gtest.sln`.

4) Build the solution.

For building unit tests, the application needs to know where the googletest libraries (debug & release) are located.

The following environment variables should be defined:

| Name                     | Value                                         |
|--------------------------|-----------------------------------------------|
|  GOOGLETEST_HOME         | c:\projects\SoftTimers\third_party\googletest |

Note that the `GOOGLETEST_HOME` variable should match the actual directory where the source code was extracted.
 
### win32Arduino

1) Download the [win32Arduino source code](https://github.com/end2endzone/win32Arduino/tags) and extract the content to a local directory (for example `c:\projects\SoftTimers\third_party\win32Arduino`).

2) Follow build and installation instructions in `c:\projects\SoftTimers\third_party\win32Arduino\INSTALL.md` file.

### SoftTimers

1) Download the [project source code](https://github.com/end2endzone/SoftTimers/tags) and extract the content to a temporary directory (for example c:\projects\SoftTimers).

2) ???

3) Build the solution.

### Deploy packages

The library is deployed as a zip package.

Execute the following steps to build the deploy package:

1) ???

2) ???
