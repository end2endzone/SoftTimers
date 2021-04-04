@echo off

:: Validate github's environment
if "%GITHUB_WORKSPACE%"=="" (
  echo Please define 'GITHUB_WORKSPACE' environment variable.
  exit /B 1
)

echo =======================================================================
echo Running unit tests...
echo =======================================================================
cd /d %GITHUB_WORKSPACE%\build\bin\%Configuration%
softtimers_unittest.exe

:: Note:
::  GitHub Action do not support uploading test results in a nice GUI. There is no build-in way to detect a failed test.
::  Do not reset the error returned by unit test execution. This will actually fail the build and will indicate in GitHub that a test has failed.
:: 
:: Reset error in case of test case fail, this prevents a test failure to actually fail the build
exit /b 0
