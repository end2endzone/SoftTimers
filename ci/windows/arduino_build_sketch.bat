@echo off

:: Set PRODUCT_SOURCE_DIR root directory
setlocal enabledelayedexpansion
if "%PRODUCT_SOURCE_DIR%"=="" (
  :: Delayed expansion is required within parentheses https://superuser.com/questions/78496/variables-in-batch-file-not-being-set-when-inside-if
  cd /d "%~dp0"
  cd ..\..
  set PRODUCT_SOURCE_DIR=!CD!
  cd ..\..
  echo PRODUCT_SOURCE_DIR set to '!PRODUCT_SOURCE_DIR!'.
)
endlocal & set PRODUCT_SOURCE_DIR=%PRODUCT_SOURCE_DIR%
echo.

:: Check Arduino CLI installation
echo Expecting Arduino CLI installed in directory: %ARDUINO_CLI_INSTALL_DIR%
echo Searching for arduino cli executable...
set PATH=%PATH%;%ARDUINO_CLI_INSTALL_DIR%
where arduino-cli.exe
if %errorlevel% neq 0 exit /b %errorlevel%
echo.

set ARDUINO_INO_FILE=%PRODUCT_SOURCE_DIR%\examples\%~1\%~1.ino

echo ==========================================================================================================
echo Compiling %ARDUINO_INO_FILE%
echo ==========================================================================================================
cd /d "%PRODUCT_SOURCE_DIR%\examples\%~1"
arduino-cli compile -b arduino:avr:nano:cpu=atmega328 %~1.ino
if %errorlevel% neq 0 exit /b %errorlevel%

cd /d "%~dp0"
