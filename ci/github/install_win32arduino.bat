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
echo Cloning win32Arduino into %GITHUB_WORKSPACE%\third_parties\win32Arduino
echo ============================================================================
mkdir %GITHUB_WORKSPACE%\third_parties >NUL 2>NUL
cd %GITHUB_WORKSPACE%\third_parties
git clone "https://github.com/end2endzone/win32Arduino.git"
cd win32Arduino
echo.

echo Checking out version 2.3.1...
git checkout 2.3.1
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
