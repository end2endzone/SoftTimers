@echo off

:: Validate appveyor's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

set GTEST_ROOT=%GITHUB_WORKSPACE%\third_parties\googletest\install
set rapidassist_DIR=%GITHUB_WORKSPACE%\third_parties\RapidAssist\install
set win32arduino_DIR=%GITHUB_WORKSPACE%\third_parties\win32Arduino\install

echo ============================================================================
echo Generating SoftTimers...
echo ============================================================================
cd /d %GITHUB_WORKSPACE%
mkdir build >NUL 2>NUL
cd build
cmake -DSOFTTIMERS_BUILD_EXAMPLES=ON ..
if %errorlevel% neq 0 exit /b %errorlevel%

echo ============================================================================
echo Compiling SoftTimers...
echo ============================================================================
cmake --build . --config Release
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

::Delete all temporary environment variable created
set GTEST_ROOT=
set rapidassist_DIR=
set win32arduino_DIR=

::Return to launch folder
cd /d %~dp0
