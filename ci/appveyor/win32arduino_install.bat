@echo off

echo =======================================================================
echo Finding root folder of repository
echo =======================================================================
cd /d %~dp0
cd ..\..
set REPOSITORY_ROOT=%cd%
echo REPOSITORY_ROOT=%REPOSITORY_ROOT%
echo done.
echo.

set WIN32ARDUINO_HOME=%REPOSITORY_ROOT%\third_party\win32arduino
echo Downloading win32Arduino to folder %WIN32ARDUINO_HOME%
echo.

echo ======================================================================
echo Deleting win32arduino repository folder (if any)
echo =======================================================================
if EXIST %WIN32ARDUINO_HOME% (
  rmdir /q/s %WIN32ARDUINO_HOME%
)
echo done.
echo.

echo ======================================================================
echo Cloning win32arduino repository
echo =======================================================================
git clone https://github.com/end2endzone/win32Arduino.git %WIN32ARDUINO_HOME%
cd /d %WIN32ARDUINO_HOME%
echo done.
echo.

echo =======================================================================
echo Generating win32arduino Visual Studio 2010 solution
echo =======================================================================
cd /d %WIN32ARDUINO_HOME%\cmake

echo Deleting previous build folder (if any)
rmdir /s/q build >NUL 2>NUL
echo done.
echo.

echo Creating build folder.
call vs2010.bat
echo done.
echo.
