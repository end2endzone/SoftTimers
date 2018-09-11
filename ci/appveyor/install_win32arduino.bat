@echo off

:: Validate appveyor's environment
if "%APPVEYOR_BUILD_FOLDER%"=="" (
  echo Please define 'APPVEYOR_BUILD_FOLDER' environment variable.
  exit /B 1
)

set GTEST_ROOT=%APPVEYOR_BUILD_FOLDER%\third_parties\googletest\install
set rapidassist_DIR=%APPVEYOR_BUILD_FOLDER%\third_parties\RapidAssist\install
set win32arduino_DIR=%APPVEYOR_BUILD_FOLDER%\third_parties\win32Arduino\install

echo ============================================================================
echo Cloning win32Arduino into %APPVEYOR_BUILD_FOLDER%\third_parties\win32Arduino
echo ============================================================================
mkdir %APPVEYOR_BUILD_FOLDER%\third_parties >NUL 2>NUL
cd %APPVEYOR_BUILD_FOLDER%\third_parties
git clone "https://github.com/end2endzone/win32Arduino.git"
cd win32Arduino
echo.

echo Checking out version 2.3.0-rc.1...
git checkout 2.3.0-rc.1
echo.

echo ============================================================================
echo Compiling...
echo ============================================================================
mkdir build >NUL 2>NUL
cd build
cmake -DCMAKE_INSTALL_PREFIX=%win32arduino_DIR% ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config Release
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing into %win32arduino_DIR%
echo ============================================================================
cmake --build . --config Release --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
