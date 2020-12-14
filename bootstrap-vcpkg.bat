@echo off
setx -m VCPKG_DEFAULT_TRIPLET x64-windows
powershell.exe -NoProfile -ExecutionPolicy Bypass "& {& '%~dp0scripts\bootstrap.ps1' %*}"
