@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
if "%~1"=="" (
    set /p "BRANCH_NAME=Please enter branch name: "
) else (
    set "BRANCH_NAME=%~1"
)

:: Prompt for front destination
if "%~2"=="" (
    set /p "PROJECT_PATH=Please enter the backend project path [ex: SCHOOL_NAME]: "
) else (
    set "PROJECT_PATH=%~2"
)

set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"

set "REMOVE_WORKTEE=%~3"
if not defined REMOVE_WORKTEE (
    set /p "REMOVE_WORKTEE=Do you want to remove the worktree? [y/n] [default: n]: "
    if "!REMOVE_WORKTEE!"=="" set "REMOVE_WORKTEE=n"
)

set "PEM_FILE=%~4"
if not defined PEM_FILE (
    set /p "PEM_FILE=Please enter the PEM file path: "
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
)

REM Set SERVER_USER from the 4th argument
set "SERVER_USER=%~5"
if not defined SERVER_USER (
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
)

REM Set SERVER_IP from the 5th argument
set "SERVER_IP=%~6"
if not defined SERVER_IP (
    set /p "SERVER_IP=Please enter the server IP [default: dev.learnovia.com]: "
    if "!SERVER_IP!"=="" set "SERVER_IP=dev.learnovia.com"
)
===============================================================================

if "%REMOVE_WORKTEE%"=="y" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo git worktree remove %BRANCH_NAME% --force && sudo rm -rf %PROJECT_PATH%/../worktrees/%BRANCH_NAME%"
    echo Removed worktree "%BRANCH_NAME%" from %PROJECT_PATH%
    pause
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && git worktree list"
    pause
    exit /b 0
)
echo Uploading "create_worktree.sh" to %SERVER_USER%@%SERVER_IP%:%PROJECT_PATH%/
scp -i %PEM_FILE% "C:\Users\omara\OneDrive\Desktop\Automation_scripts\create_worktree.sh" %SERVER_USER%@%SERVER_IP%:%PROJECT_PATH%/

if %ERRORLEVEL% NEQ 0 (
    echo Failed to upload "create_worktree.sh" to %SERVER_USER%@%SERVER_IP%:%PROJECT_PATH%/
    pause
    exit /b %ERRORLEVEL%
)
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo chmod +x %PROJECT_PATH%/create_worktree.sh && sed -i 's/\r$//' %PROJECT_PATH%/create_worktree.sh"

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo ./create_worktree.sh "%PROJECT_PATH%/../worktrees/%BRANCH_NAME%" "%BRANCH_NAME%" "	

pause
endlocal