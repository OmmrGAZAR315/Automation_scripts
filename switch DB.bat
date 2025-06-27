@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

echo dev mob front shahadat new
:: Prompt for front destination
set /p "PROJECT_PATH=Please enter the front project path [SCHOOL_NAME]: "
set /p "DROP_DB=Do you want to drop the database? [y/n]: "

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
    set "PROJECT_PATH=/schools/%PROJECT_PATH%/backend"
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
if "!DROP_DB!"=="" set "DROP_DB=n"

set "SERVER_IP=%SERVER_IP%.learnovia.com"
set "domains=dev mob front shahadat new"
===============================================================================
echo.
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'" | findstr /V "information_schema" | findstr /V "mysql" | findstr /V "sys" | findstr /V "performance_schema"
echo.
if "%DROP_DB%" == "y" (

:drop_db
for %%D in (%domains%) do (
    set "NEW_PROJECT_PATH=/schools/%%D/backend"
    echo %%D
    echo.
    ssh -i %PEM_FILE% -o StrictHostKeyChecking=no %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^MYSQL_DATABASE=\K.*' !NEW_PROJECT_PATH!/.env"
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

    set /p "DROP_DB=Do you want to drop another database? [y/n]: "
    if "!DROP_DB!"=="" set "DROP_DB=n"
    if "!DROP_DB!" == "y" (
        ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'" | findstr /V "information_schema" | findstr /V "mysql"
        echo.
        goto :drop_db
    ) else (
        echo.
        echo.
        echo Database drop process completed
        echo.
        echo.
    )
)

echo server databse selected is:
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^MYSQL_DATABASE=\K.*' %PROJECT_PATH%/.env"


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
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% " sudo sed -i 's/^MYSQL_DATABASE=.*/MYSQL_DATABASE=%DB%/' %PROJECT_PATH%/.env "

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && php artisan optimize:clear"

echo Database name changed successfully

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo grep -Po '^MYSQL_DATABASE=\K.*' %PROJECT_PATH%/.env"


set /p "RUN_MIGRATIONS=Do you want to run migrations? [y/n]: "
if "!RUN_MIGRATIONS!"=="" set "RUN_MIGRATIONS=n"
echo.
if /i "!RUN_MIGRATIONS!" == "y" (
    echo Running migrations...
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && php artisan migrate --no-interaction"
    echo Seeding database...
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && php artisan db:seed --class=TranslationSeeder"
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && php artisan db:seed --class=PermissionSeeder"
    echo Done migrating and seeding database.
    @REM ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "cd %PROJECT_PATH% && php artisan db:seed --class=PermTranSeeders"    
)

:: set /p "RUN_MIGRATIONS=Do you want to run migrations? [y/n]: "
:: if "!RUN_MIGRATIONS!"=="" set "RUN_MIGRATIONS=n"
:: if /i "!RUN_MIGRATIONS!" == "y" (
::     echo Running migrations...
:: )


pause
endlocal