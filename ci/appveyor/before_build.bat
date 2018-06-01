@echo off

cd /d %~dp0
cd ..\..
mkdir build >NUL 2>NUL
cd build
cmake -DSOFTTIMERS_BUILD_TEST=ON -DSOFTTIMERS_BUILD_EXAMPLES=ON -DSOFTTIMERS_BUILD_DOC=ON ..
