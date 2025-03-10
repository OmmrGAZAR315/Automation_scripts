@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

echo dev mob front shahadat
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
    set /p "SERVER_IP=Please enter the server IP [default: dev]: "
    set /p "DB_PASS=Please enter db password: "
    set /p "PEM_FILE=Please enter the PEM file path: "
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
)

if "!SERVER_IP!"=="" set "SERVER_IP=dev"
if "!DB_PASS!"=="" set "DB_PASS=Learnovia_2025*modern2025"
if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"

set "SERVER_IP=%SERVER_IP%.learnovia.com"
set "domains=dev mob front shahadat"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'"
echo.
set /p "DROP_DB=Do you want to drop the database? [y/n]: "
if "%DROP_DB%" == "y" (
   

for %%D in (%domains%) do (
    set "NEW_PROJECT_PATH=/schools/%%D/learnovia-backend"
    echo %%D
    echo.
    ssh -i %PEM_FILE% -o StrictHostKeyChecking=no %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^DB_DATABASE=\K.*' !NEW_PROJECT_PATH!/.env"
)
     set /p "DB_NAME=Please enter the database name: "

    if "!DB_NAME!"=="" (
        echo "Database name is required"
        pause
        exit
    )
    if not "!DB_NAME!"=="" (
        echo Dropping database !DB_NAME! on !SERVER_IP!
        ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mysql -u root -p%DB_PASS% -e 'DROP DATABASE !DB_NAME!;'"
        echo Database dropped successfully
    )
)

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

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && php artisan optimize:clear"

echo Database name changed successfully

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^DB_DATABASE=\K.*' %PROJECT_PATH%/.env"

pause
endlocal