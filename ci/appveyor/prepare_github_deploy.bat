@echo off
set APPVEYOR_PROJECT_NAME=RapidAssist
set APPVEYOR_BUILD_NUMBER=9999
set APPVEYOR_BUILD_VERSION=3.4.5.%APPVEYOR_BUILD_NUMBER%
set SEMVER_STRING=3.4.5
set APPVEYOR_REPO_BRANCH=prerelease
powershell -nologo -executionpolicy bypass -File "%~dpn0.ps1"
pause
