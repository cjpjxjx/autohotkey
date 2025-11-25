@echo off
title AutoHotkey 脚本重载工具

:: =================================================================
:: 提权逻辑：检查参数，若无则使用 runas 提权并重新运行自身
:: 提权后重新运行时，会传入 :: 作为第一个参数
:: 此时这一整行因以 : 开头而被忽略，从而跳过提权，避免死循环
:: =================================================================
%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c ""%~s0"" ::","","runas",1)(window.close)&&exit

:: =================================================================
:: 提权后执行的命令（只有在管理员窗口中才会运行到这里）
:: =================================================================

:: 切换到批处理脚本所在的目录
cd /d "%~dp0"

echo.
echo ========================================
echo   AutoHotkey 脚本重载工具
echo ========================================
echo.
echo 正在终止 AutoHotkey 进程...

:: 终止所有 AutoHotkey 进程
taskkill /F /IM AutoHotkey64.exe >nul 2>&1
taskkill /F /IM AutoHotkey32.exe >nul 2>&1
taskkill /F /IM AutoHotkeyU64.exe >nul 2>&1
taskkill /F /IM AutoHotkeyU32.exe >nul 2>&1

:: 等待进程完全终止
timeout /t 1 /nobreak >nul

echo AutoHotkey 进程已终止
echo.
echo 正在启动脚本...

:: 启动主脚本（使用脚本所在目录）
start "" "%~dp0Main.ahk"

echo.
echo ========================================
echo   脚本已成功重载！
echo ========================================
echo.
