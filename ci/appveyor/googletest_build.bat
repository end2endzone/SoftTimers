echo =======================================================================
echo Building googletest solution: %GOOGLETEST_HOME%\build\gtest.sln
echo =======================================================================
cd /d %GOOGLETEST_HOME%\build
msbuild "gtest.sln" /m /verbosity:minimal
echo done.
echo.
echo.
