@echo off
chcp 65001 >nul
title Knowledge Iteration Kit - Installer
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
set "EXITCODE=%errorlevel%"
echo.
pause
exit /b %EXITCODE%
