@echo off

:: Validate appveyor's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

set CMAKE_INSTALL_PREFIX=%GITHUB_WORKSPACE%\third_parties\RapidAssist\install
set CMAKE_PREFIX_PATH=
set CMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH%;%GITHUB_WORKSPACE%\third_parties\googletest\install

echo ============================================================================
echo Cloning RapidAssist into %CMAKE_INSTALL_PREFIX%
echo ============================================================================
mkdir %GITHUB_WORKSPACE%\third_parties >NUL 2>NUL
cd %GITHUB_WORKSPACE%\third_parties
git clone "https://github.com/end2endzone/RapidAssist.git"
cd RapidAssist
echo.

echo Checking out version v0.5.0...
git -c advice.detachedHead=false checkout 0.5.0
echo.

echo ============================================================================
echo Compiling RapidAssist...
echo ============================================================================
mkdir build >NUL 2>NUL
cd build
cmake -DCMAKE_GENERATOR_PLATFORM=%Platform% -T %PlatformToolset% -DCMAKE_CXX_FLAGS="/D_SILENCE_TR1_NAMESPACE_DEPRECATION_WARNING /DWIN32" -DCMAKE_INSTALL_PREFIX=%CMAKE_INSTALL_PREFIX% -DCMAKE_PREFIX_PATH=%CMAKE_PREFIX_PATH% ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config %Configuration%
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing RapidAssist into %CMAKE_INSTALL_PREFIX%
echo ============================================================================
cmake --build . --config %Configuration% --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
