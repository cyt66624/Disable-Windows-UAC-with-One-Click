@echo off
title Windows UAC ���Ƴ���,һ������UAC,���ߣ�LILI
color 0F

:: ���ô���ҳΪ����
chcp 936 >nul 2>&1

:: ������ԱȨ��
fltmc >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] ��⵽����ԱȨ�ޣ�����ִ��...
) else (
    echo [ERROR] �˽ű���Ҫ����ԱȨ�����У�
    echo ���Ҽ�����ű�ѡ��"�Թ���Ա�������"
    pause
    exit /b 1
)

:main_menu
cls
echo.
echo ==========================================
echo     Windows UAC ���Ƴ���,���ߣ�LILI
echo ==========================================
echo.
echo ��ѡ��Ҫִ�еĲ�����
echo.
echo [1] ���������˺�UAC��ϵͳ����
echo [2] ���������˺�UAC��ϵͳ����
echo [3] �鿴��ǰUAC״̬
echo [4] �˳�
echo.
set /p choice="������ѡ���� (1-4): "

if "%choice%"=="1" goto disable_uac
if "%choice%"=="2" goto enable_uac
if "%choice%"=="3" goto check_status
if "%choice%"=="4" goto exit_script
echo [ERROR] ��Чѡ�������ѡ��
timeout /t 2 >nul
goto main_menu

:disable_uac
echo.
echo [INFO] ���ڽ��������˺�UAC...
echo.

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] UAC�ѳɹ����ã�
    echo [INFO] ��Ҫ���������������Ч
) else (
    echo [ERROR] ����UACʧ�ܣ��������: %errorLevel%
)

goto next_step

:enable_uac
echo.
echo [INFO] �������������˺�UAC...
echo.

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f >nul 2>&1
if %errorLevel% == 0 (
    echo [SUCCESS] UAC�ѳɹ����ã�
    echo [INFO] ��Ҫ���������������Ч
) else (
    echo [ERROR] ����UACʧ�ܣ��������: %errorLevel%
)

goto next_step

:check_status
echo.
echo [INFO] ���ڼ�鵱ǰUAC״̬...
echo.

:: ���EnableLUAֵ
for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA 2^>nul ^| find "EnableLUA"') do set uac_status=%%a

echo ==========================================
echo           ��ǰUAC״̬
echo ==========================================
echo.

if "%uac_status%"=="0x1" (
    echo [״̬] UAC: ������
) else if "%uac_status%"=="0x0" (
    echo [״̬] UAC: �ѽ���
) else (
    echo [״̬] UAC: δ֪״̬ ^(ֵ: %uac_status%^)
)

echo.
echo ==========================================

goto next_step

:next_step
echo.
echo ��ѡ����һ��������
echo.
echo [1] �鿴��ǰUAC״̬
echo [2] �������˵�
echo [3] �˳�
echo.
set /p next_choice="������ѡ���� (1-3): "

if "%next_choice%"=="1" goto check_status
if "%next_choice%"=="2" goto main_menu
if "%next_choice%"=="3" goto exit_script

echo [ERROR] ��Чѡ�������ѡ��
timeout /t 2 >nul
goto next_step

:exit_script
echo.
echo [INFO] ��лʹ�ã��ű������˳�...
timeout /t 1 >nul
exit