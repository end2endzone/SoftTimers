@echo off

:: Validate github's environment
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
cmake -DCMAKE_GENERATOR_PLATFORM=%Platform% -T %PlatformToolset% -DCMAKE_INSTALL_PREFIX=%GITHUB_WORKSPACE%\third_parties\googletest\install -Dgtest_force_shared_crt=ON -DBUILD_GMOCK=OFF -DBUILD_GTEST=ON ..
if %errorlevel% neq 0 exit /b %errorlevel%
cmake --build . --config %Configuration% -- -maxcpucount /m
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

echo ============================================================================
echo Installing into %GITHUB_WORKSPACE%\third_parties\googletest\install
echo ============================================================================
cmake --build . --config %Configuration% --target INSTALL
if %errorlevel% neq 0 exit /b %errorlevel%
echo.
