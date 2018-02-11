//
//  win32Arduino Library - v1.3 - 06/03/2016
//  Copyright (C) 2016 Antoine Beauchamp
//  The code & updates for the library can be found on http://end2endzone.com
//
// AUTHOR/LICENSE:
//  This library is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License as published by the Free Software Foundation; either
//  version 3.0 of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License (LGPL-3.0) for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with this library; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
//
// DISCLAIMER:
//  This software is furnished "as is", without technical support, and with no 
//  warranty, express or implied, as to its usefulness for any purpose.
//
// PURPOSE:
//  The win32Arduino is a win32 library that implementation of most used arduino
//  functions which allows a library developer to unit test his code outside of
//  the arduino platform.
//
//  This library allows a windows user to easily test an arduino library using
//  your testing framework of choice. For instance, the unit tests of win32Arduino
//  library are executed using the Google Test framework.
//
// USAGE:
//  The following instructions show how to easily test an arduino library using
//  the Google Test framework. It assumes that you are already familiar with the
//  test API.
//
//  1. Create an executable project and configure the main() function to launch
//     Google Test's RUN_ALL_TESTS() macro.
//  2. Create a second static library project and add all the arduino files of
//     the desired library you need to test.
//  3. The library files are expected to include arduino.h. Modify the project's
//     Additionnal Include Directories to point to the win32Arduino library.
//
//  The project should compile properly without errors or unresolved extensions
//  allowing you to properly unit test each functions.
//
// HISTORY:
// 05/13/2016 v1.0 - Initial release.
// 05/14/2016 v1.1 - Implemented both simulated & realtime clock handling. The desired strategy is user selectable.
// 05/20/2016 v1.2 - Fixed tone() signature to match arduino's IDE.
// 06/03/2016 v1.3 - Implemented support for forcing current time in SIMULATION mode.
//                 - Implemented SREG and cli() function support
//                 - Fixed analogWrite() signature
//                 - Fixed constants definitions based on Arduino Nano v3 values
//                 - Removed support for HIGH and LOW interrupts support which is creating too much confusion.
//

#ifndef WIN32_SERIALPRINTER_H
#define WIN32_SERIALPRINTER_H

#include "arduinoBaseTypes.h"

class SerialPrinter
{
public:

  static void begin(uint16_t baudrate);
  static void printString(const char * iValue);
  static void printlnString(const char * iValue);

  //Note: http://www.parashift.com/c++-faq-lite/misc-technical-issues.html#faq-39.2
  template <class T>
  inline void print(const T & t, int /*iRadix*/)
  {
    std::stringstream out;
    out << t;
    printString(out.str().c_str());
  }

  template <class T>
  inline void println(const T & t, int /*iRadix*/)
  {
    std::stringstream out;
    out << t;
    printlnString(out.str().c_str());
  }

  template <class T>
  inline void print(const T & t)
  {
    std::stringstream out;
    out << t;
    printString(out.str().c_str());
  }

  template <class T>
  inline void println(const T & t)
  {
    std::stringstream out;
    out << t;
    printlnString(out.str().c_str());
  }

  //specializations
  template<>
  inline void print<uint8_t>(const uint8_t & t, int /*iRadix*/)
  {
    std::stringstream out;
    out << (int)t;
    printString(out.str().c_str());
  }
  template<>
  inline void println<uint8_t>(const uint8_t & t, int /*iRadix*/)
  {
    std::stringstream out;
    out << (int)t;
    printlnString(out.str().c_str());
  }
  template<>
  inline void print<uint8_t>(const uint8_t & t)
  {
    std::stringstream out;
    out << (int)t;
    printString(out.str().c_str());
  }
  template<>
  inline void println<uint8_t>(const uint8_t & t)
  {
    std::stringstream out;
    out << (int)t;
    printlnString(out.str().c_str());
  }

  static void println();
};

#endif //WIN32_SERIALPRINTER_H