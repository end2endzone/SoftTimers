@echo off

:: Validate appveyor's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

echo ============================================================================
echo Generating SoftTimers...
echo ============================================================================
cd /d %GITHUB_WORKSPACE%
mkdir build >NUL 2>NUL
cd build
cmake -DCMAKE_GENERATOR_PLATFORM=%Platform% -T %PlatformToolset% -DCMAKE_CXX_FLAGS=/D_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING -DCMAKE_PREFIX_PATH=%GITHUB_WORKSPACE%\third_parties\googletest\install;%GITHUB_WORKSPACE%\third_parties\RapidAssist\install;%GITHUB_WORKSPACE%\third_parties\win32Arduino\install -DSOFTTIMERS_BUILD_EXAMPLES=ON ..
if %errorlevel% neq 0 exit /b %errorlevel%

echo ============================================================================
echo Compiling SoftTimers...
echo ============================================================================
cmake --build . --config %Configuration%
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

::Return to launch folder
cd /d %~dp0
