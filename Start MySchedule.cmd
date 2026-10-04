@echo off
setlocal
set "SCHEDULER_EXE=%~dp0dist\MySchedule\MySchedule.exe"
if not exist "%SCHEDULER_EXE%" (
    echo MySchedule has not been packaged yet.
    echo Run scripts\package.cmd to build the application first.
    pause
    exit /b 1
)
start "" "%SCHEDULER_EXE%"
exit /b 0
