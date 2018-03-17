echo =======================================================================
echo Building win32arduino solution: %WIN32ARDUINO_HOME%\cmake\build\win32arduino.sln
echo =======================================================================
cd /d %WIN32ARDUINO_HOME%\cmake\build
msbuild "win32arduino.sln" /m /verbosity:minimal
echo done.
echo.
