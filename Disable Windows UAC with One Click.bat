@echo off
title Windows UAC 控制程序,一键禁用UAC,作者：LILI
color 0F

:: 设置代码页为中文
chcp 936 >nul 2>&1

:: 检查管理员权限
fltmc >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] 检测到管理员权限，继续执行...
) else (
    echo [ERROR] 此脚本需要管理员权限运行！
    echo 请右键点击脚本选择"以管理员身份运行"
    pause
    exit /b 1
)

:main_menu
cls
echo.
echo ==========================================
echo     Windows UAC 控制程序,作者：LILI
echo ==========================================
echo.
echo 请选择要执行的操作：
echo.
echo [1] 禁用所有账号UAC（系统级）
echo [2] 启用所有账号UAC（系统级）
echo [3] 查看当前UAC状态
echo [4] 退出
echo.
set /p choice="请输入选项编号 (1-4): "

if "%choice%"=="1" goto disable_uac
if "%choice%"=="2" goto enable_uac
if "%choice%"=="3" goto check_status
if "%choice%"=="4" goto exit_script
echo [ERROR] 无效选项，请重新选择！
timeout /t 2 >nul
goto main_menu

:disable_uac
echo.
echo [INFO] 正在禁用所有账号UAC...
echo.

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] UAC已成功禁用！
    echo [INFO] 需要重启计算机才能生效
) else (
    echo [ERROR] 禁用UAC失败！错误代码: %errorLevel%
)

goto next_step

:enable_uac
echo.
echo [INFO] 正在启用所有账号UAC...
echo.

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] UAC已成功启用！
    echo [INFO] 需要重启计算机才能生效
) else (
    echo [ERROR] 启用UAC失败！错误代码: %errorLevel%
)

goto next_step

:check_status
echo.
echo [INFO] 正在检查当前UAC状态...
echo.

:: 检查EnableLUA值
for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA 2^>nul ^| find "EnableLUA"') do set uac_status=%%a

echo ==========================================
echo           当前UAC状态
echo ==========================================
echo.

if "%uac_status%"=="0x1" (
    echo [状态] UAC: 已启用
) else if "%uac_status%"=="0x0" (
    echo [状态] UAC: 已禁用
) else (
    echo [状态] UAC: 未知状态 ^(值: %uac_status%^)
)

echo.
echo ==========================================

goto next_step

:next_step
echo.
echo 请选择下一步操作：
echo.
echo [1] 查看当前UAC状态
echo [2] 返回主菜单
echo [3] 退出
echo.
set /p next_choice="请输入选项编号 (1-3): "

if "%next_choice%"=="1" goto check_status
if "%next_choice%"=="2" goto main_menu
if "%next_choice%"=="3" goto exit_script

echo [ERROR] 无效选项，请重新选择！
timeout /t 2 >nul
goto next_step

:exit_script
echo.
echo [INFO] 感谢使用！脚本即将退出...
timeout /t 1 >nul
exit