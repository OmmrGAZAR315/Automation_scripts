@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
set /p "PROJECT_PATH=Please enter the front project path [SCHOOL_NAME]: "

:: prompt for worktree
set /p "IS_WORKTREE_EXISTS=Is this a worktree? [y/n]: "
if "!IS_WORKTREE_EXISTS!"=="" set "IS_WORKTREE_EXISTS=n"

if "!IS_WORKTREE_EXISTS!" == "y" (
    set /p "BRANCH_NAME=Please enter the Branch name: "
    if "!BRANCH_NAME!"=="" (
        echo "Branch name is required"
        pause
        exit
    )
    set "PROJECT_PATH=/schools/%PROJECT_PATH%/worktrees/!BRANCH_NAME!"
) else (
    :: Append /dist to the upload destination
    set "PROJECT_PATH=/schools/%PROJECT_PATH%/learnovia-backend"
)

:: prompt for config
set /p "CUSTOM=DO YOU WANT TO USE CONFIG? [y/n]: "
if "!CUSTOM!"=="" set "CUSTOM=n"

if /I "!CUSTOM!" == "y" (
    set /p "DB_PASS=Please enter db password: "

    set /p "PEM_FILE=Please enter the PEM file path: "

    REM Set SERVER_USER from the 4th argument
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "

    set /p "SERVER_IP=Please enter the server IP [default: dev]: "
) else (
    if "!DB_PASS!"=="" set "DB_PASS=Learnovia_2025*modern2025"
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
    if "!SERVER_IP!"=="" set "SERVER_IP=dev"
)

set "SERVER_IP=%SERVER_IP%.learnovia.com"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'"
echo.

echo server databse selected is:
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^DB_DATABASE=\K.*' %PROJECT_PATH%/.env"


echo.
echo.
:: Prompt for front destination
if "%~1"=="" (
    set /p "DB=Please enter the database name: "
) else (
    set "DB=%~1"
)

if "%DB%"=="" (
    echo "Database name is required"
    pause
    exit
)
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% " sudo sed -i 's/^DB_DATABASE=.*/DB_DATABASE=%DB%/' %PROJECT_PATH%/.env "

echo Database name changed successfully

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^DB_DATABASE=\K.*' %PROJECT_PATH%/.env"

pause
endlocal