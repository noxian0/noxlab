@echo off
setlocal

net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process cmd.exe -Verb RunAs -ArgumentList '/c ""\""%~dp0NoxLab CMD Host.cmd\"" ""'"
    exit /b
)

call "%~dp0NoxLab CMD Host.cmd"
