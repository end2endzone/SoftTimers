@echo off

:: Validate appveyor's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

set GTEST_ROOT=%GITHUB_WORKSPACE%\third_parties\googletest\install
set rapidassist_DIR=%GITHUB_WORKSPACE%\third_parties\RapidAssist\install
echo rapidassist_DIR=%rapidassist_DIR%

echo ============================================================================
echo Cloning RapidAssist into %GITHUB_WORKSPACE%\third_parties\RapidAssist
echo ============================================================================
mkdir %GITHUB_WORKSPACE%\third_parties >NUL 2>NUL
cd %GITHUB_WORKSPACE%\third_parties
git clone "https://github.com/end2endzone/RapidAssist.git"
cd RapidAssist
echo.

echo Checking out version v0.5.0...
git checkout 0.5.0
echo.

echo ============================================================================
echo Compiling...
echo ============================================================================
mkdir build >NUL 2>NUL
cd build
cmake -DCMAKE_INSTALL_PREFIX=%rapidassist_DIR% ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config Release
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing into %rapidassist_DIR%
echo ============================================================================
cmake --build . --config Release --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
