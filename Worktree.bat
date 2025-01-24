@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
    set /p "BRANCH_NAME=Please enter branch name: "

:: Prompt for front destination
    set /p "PROJECT_PATH=Please enter the backend project path [ex: SCHOOL_NAME]: "

set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"

set /p "REMOVE_WORKTEE=Do you want to remove the worktree? [y/n] [default: n]: "
if "!REMOVE_WORKTEE!"=="" set "REMOVE_WORKTEE=n"

:: prompt for config
set /p "CUSTOM=DO YOU WANT TO USE CONFIG? [y/n]: "
if "!CUSTOM!"=="" set "CUSTOM=n"

if /I "!CUSTOM!" == "y" (
    set /p "PEM_FILE=Please enter the PEM file path: "
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    set /p "SERVER_IP=Please enter the server IP [default: dev]: "

) else (
    if "!REMOVE_WORKTEE!"=="" set "REMOVE_WORKTEE=n"
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
    if "!SERVER_IP!"=="" set "SERVER_IP=dev"
)
:: Append .learnovia.com to the server ip
set "SERVER_IP=%SERVER_IP%.learnovia.com"
===============================================================================

if "%REMOVE_WORKTEE%"=="y" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "ls %PROJECT_PATH%/../worktrees/"
    set /p "DIR_NAME=Please enter the branch name you want to remove: "
    if not "!DIR_NAME!"=="" (
        if "!DIR_NAME!"=="all" (
            ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo rm -rf %PROJECT_PATH%/../worktrees/*"
            echo Removed all worktrees from %PROJECT_PATH%../worktrees/
        ) else (
            ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo rm -rf %PROJECT_PATH%/../worktrees/!DIR_NAME!"
        )
    ) else (
        ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo git worktree remove %BRANCH_NAME% --force; sudo rm -rf %PROJECT_PATH%/../worktrees/%BRANCH_NAME%"
        echo Removed worktree "%BRANCH_NAME%" from %PROJECT_PATH%
        pause
    )
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

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo git config --global --add safe.directory $(pwd)"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && sudo ./create_worktree.sh "%PROJECT_PATH%/../worktrees/%BRANCH_NAME%" "%BRANCH_NAME%" "	

pause
endlocal