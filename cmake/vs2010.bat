@echo off
cd /d %~dp0

::Find src folder
cd..
cd src
set SRC_DIR=%cd%
cd /d %~dp0

REM Create build directory
mkdir build >NUL 2>NUL
cd build

cmake -G "Visual Studio 10 2010" %SRC_DIR%
