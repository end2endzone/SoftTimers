@echo off

:: Validate mandatory environment variables
if "%CONFIGURATION%"=="" (
  echo Please define 'Configuration' environment variable.
  exit /B 1
)
if "%PLATFORM%"=="" (
  echo Please define 'Platform' environment variable.
  exit /B 1
)

:: Set PRODUCT_SOURCE_DIR root directory
setlocal enabledelayedexpansion
if "%PRODUCT_SOURCE_DIR%"=="" (
  :: Delayed expansion is required within parentheses https://superuser.com/questions/78496/variables-in-batch-file-not-being-set-when-inside-if
  cd /d "%~dp0"
  cd ..\..
  set PRODUCT_SOURCE_DIR=!CD!
  cd ..\..
  echo PRODUCT_SOURCE_DIR set to '!PRODUCT_SOURCE_DIR!'.
)
endlocal & set PRODUCT_SOURCE_DIR=%PRODUCT_SOURCE_DIR%
echo.

:: Prepare CMAKE parameters
set CMAKE_INSTALL_PREFIX=%PRODUCT_SOURCE_DIR%\third_parties\win32Arduino\install
set CMAKE_PREFIX_PATH=
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;%PRODUCT_SOURCE_DIR%\third_parties\googletest\install;
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;%PRODUCT_SOURCE_DIR%\third_parties\RapidAssist\install;

echo ============================================================================
echo Cloning win32Arduino into %PRODUCT_SOURCE_DIR%\third_parties\win32Arduino
echo ============================================================================
mkdir "%PRODUCT_SOURCE_DIR%\third_parties" >NUL 2>NUL
cd "%PRODUCT_SOURCE_DIR%\third_parties"
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
cmake -Wno-dev -DCMAKE_GENERATOR_PLATFORM=%PLATFORM% -T %PLATFORMTOOLSET% -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX="%CMAKE_INSTALL_PREFIX%" -DCMAKE_PREFIX_PATH="%CMAKE_PREFIX_PATH%" ..
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Compiling win32Arduino...
echo ============================================================================
cmake --build . --config %CONFIGURATION% -- -maxcpucount /m
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing win32Arduino into %PRODUCT_SOURCE_DIR%\third_parties\win32Arduino\install
echo ============================================================================
cmake --build . --config %CONFIGURATION% --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

::Return to launch folder
cd /d "%~dp0"
