@echo off

echo =======================================================================
echo Finding root folder of repository
echo =======================================================================
cd /d %~dp0
cd ..\..
set REPOSITORY_ROOT=%cd%
echo REPOSITORY_ROOT=%REPOSITORY_ROOT%
echo done.
echo.

set GOOGLETEST_HOME=%REPOSITORY_ROOT%\third_party\googletest
echo Downloading googletest to folder %GOOGLETEST_HOME%
echo.

echo ======================================================================
echo Deleting googletest repository folder (if any)
echo =======================================================================
if EXIST %GOOGLETEST_HOME% (
  rmdir /q/s %GOOGLETEST_HOME%
)
echo done.
echo.

echo ======================================================================
echo Cloning googletest repository
echo =======================================================================
git clone https://github.com/google/googletest.git %GOOGLETEST_HOME%
cd /d %GOOGLETEST_HOME%
git checkout release-1.6.0
echo done.
echo.

echo =======================================================================
echo Generating googletest Visual Studio 2010 solution
echo =======================================================================
cd /d %GOOGLETEST_HOME%

echo Deleting previous build folder (if any)
rmdir /s/q build >NUL 2>NUL
echo done.
echo.

echo Creating build folder.
mkdir %GOOGLETEST_HOME%\build
echo done.
echo.

echo Launching cmake...
cd /d %GOOGLETEST_HOME%\build
cmake -G "Visual Studio 10 2010" -Dgtest_force_shared_crt=ON -DCMAKE_CXX_FLAGS_DEBUG=/MDd -DCMAKE_CXX_FLAGS_RELEASE=/MD "%GOOGLETEST_HOME%"
echo done.
echo.

echo =======================================================================
echo Setting environnment variables for googletest
echo =======================================================================
set GTEST_DEBUG_LIBRARIES=gtest.lib
set GTEST_RELEASE_LIBRARIES=gtest.lib
set GTEST_INCLUDE=%GOOGLETEST_HOME%\include
set GTEST_LIBRARY_DIR=%GOOGLETEST_HOME%\build
REM
setx GTEST_DEBUG_LIBRARIES %GTEST_DEBUG_LIBRARIES%
setx GTEST_RELEASE_LIBRARIES %GTEST_RELEASE_LIBRARIES%
setx GTEST_INCLUDE %GTEST_INCLUDE%
setx GTEST_LIBRARY_DIR %GTEST_LIBRARY_DIR%
REM
set GTEST_
echo done.
echo.
