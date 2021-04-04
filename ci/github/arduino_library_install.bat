@echo off

:: Navigate to root directory of repository
cd /d %~dp0
cd ..\..

setlocal

:: Copy properties as environment variables
FOR /F "tokens=1,2 delims==" %%G IN (library.properties) DO (set %%G=%%H) 
echo Installing %name%-%version% for current user

:: Cleanup
set installdir=%USERPROFILE%\Documents\Arduino\libraries\%name%-%version%
IF EXIST %installdir% (
  rmdir /S /Q %installdir%
)

:: Copy
xcopy /S /Y %cd% %installdir%\

::Cleanup
IF EXIST %installdir%\build (
  rmdir /S /Q %installdir%\build
)
IF EXIST %installdir%\third_parties (
  rmdir /S /Q %installdir%\third_parties
)

endlocal
