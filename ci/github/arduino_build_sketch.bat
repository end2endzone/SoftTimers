@echo off

:: Validate appveyor's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

:: Navigate to root directory of repository
cd /d %~dp0
cd ..\..

:: Add Arduino IDE to PATH
echo Expecting Arduino IDE installed in directory: %ARDUINO_INSTALL_DIR%
set PATH=%ARDUINO_INSTALL_DIR%;%PATH%

set ARDUINO_INO_FILE=%cd%\examples\%1\%1.ino
echo ==========================================================================================================
echo Compiling %ARDUINO_INO_FILE%
echo ==========================================================================================================

REM See https://github.com/arduino/arduino-builder/wiki/Doing-continuous-integration-with-arduino-builder for details on how to use arduino-builder

:: Build command line
set ARDUINO_BUILDER_CMDLINE=
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -compile 
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -hardware %ARDUINO_INSTALL_DIR%\hardware
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -tools %ARDUINO_INSTALL_DIR%\tools-builder
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -tools %ARDUINO_INSTALL_DIR%\hardware\tools\avr
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -built-in-libraries %ARDUINO_INSTALL_DIR%\libraries
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -libraries %USERPROFILE%\Documents\Arduino\libraries
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -fqbn=arduino:avr:nano:cpu=atmega328 -ide-version=10803
REM set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% -verbose
set ARDUINO_BUILDER_CMDLINE=%ARDUINO_BUILDER_CMDLINE% %ARDUINO_INO_FILE%

echo %ARDUINO_INSTALL_DIR%\arduino-builder %ARDUINO_BUILDER_CMDLINE%
%ARDUINO_INSTALL_DIR%\arduino-builder %ARDUINO_BUILDER_CMDLINE%
