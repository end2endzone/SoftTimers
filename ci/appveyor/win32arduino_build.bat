echo =======================================================================
echo Building win32arduino solution: %REPOSITORY_ROOT%\third_party\win32arduino\cmake\build\win32arduino.sln
echo =======================================================================
cd /d %REPOSITORY_ROOT%\third_party\win32arduino\cmake\build
msbuild "win32arduino.sln" /m /verbosity:minimal
echo done.
echo.
