@echo off
setlocal
cd /d "%~dp0"
chcp 65001 >nul
mode con cols=220 lines=220

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0NoxLab.ps1"
