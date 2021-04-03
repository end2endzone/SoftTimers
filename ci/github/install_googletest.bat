@echo off

:: Validate appveyor's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

echo ============================================================================
echo Cloning googletest into %GITHUB_WORKSPACE%\third_parties\googletest
echo ============================================================================
mkdir %GITHUB_WORKSPACE%\third_parties >NUL 2>NUL
cd %GITHUB_WORKSPACE%\third_parties
git clone "https://github.com/google/googletest.git"
cd googletest
echo.

echo Checking out version 1.8.0...
git checkout release-1.8.0
echo.

echo ============================================================================
echo Compiling...
echo ============================================================================
mkdir build >NUL 2>NUL
cd build
set GTEST_ROOT=%GITHUB_WORKSPACE%\third_parties\googletest\install
cmake -DCMAKE_INSTALL_PREFIX=%GTEST_ROOT% -Dgtest_force_shared_crt=ON -DBUILD_GMOCK=OFF -DBUILD_GTEST=ON ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config Release
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing into %GTEST_ROOT%
echo ============================================================================
cmake --build . --config Release --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
