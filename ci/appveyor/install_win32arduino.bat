@echo off

:: Validate appveyor's environment
if "%APPVEYOR_BUILD_FOLDER%"=="" (
  echo Please define 'APPVEYOR_BUILD_FOLDER' environment variable.
  exit /B 1
)

set CMAKE_INSTALL_PREFIX=%APPVEYOR_BUILD_FOLDER%\third_parties\win32Arduino\install
set CMAKE_PREFIX_PATH=
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;%APPVEYOR_BUILD_FOLDER%\third_parties\googletest\install
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;%APPVEYOR_BUILD_FOLDER%\third_parties\RapidAssist\install

echo ============================================================================
echo Cloning win32Arduino into %APPVEYOR_BUILD_FOLDER%\third_parties\win32Arduino
echo ============================================================================
mkdir %APPVEYOR_BUILD_FOLDER%\third_parties >NUL 2>NUL
cd %APPVEYOR_BUILD_FOLDER%\third_parties
git clone "https://github.com/end2endzone/win32Arduino.git"
cd win32Arduino
echo.

echo Checking out version 2.4.0...
git -c advice.detachedHead=false checkout 2.4.0
echo.

echo ============================================================================
echo Compiling win32Arduino...
echo ============================================================================
mkdir build >NUL 2>NUL
cd build
cmake -DCMAKE_GENERATOR_PLATFORM=%Platform% -T %PlatformToolset% -DCMAKE_CXX_FLAGS=/D_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING -DCMAKE_INSTALL_PREFIX=%CMAKE_INSTALL_PREFIX% -DCMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH% ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config %Configuration%
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing win32Arduino into %CMAKE_INSTALL_PREFIX%
echo ============================================================================
cmake --build . --config %Configuration% --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
