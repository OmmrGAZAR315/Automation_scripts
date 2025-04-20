@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

set /p "SERVER_IP_target=Please enter the server DOMAIN: "

:: prompt for config
set /p "CUSTOM=DO YOU WANT TO USE CONFIG? [y/n]: "
if "!CUSTOM!"=="" set "CUSTOM=n"

if /I "!CUSTOM!" == "y" (

    set /p "GET_OLD=DO YOU WANT TO GET OLD DB? [y/n]: "
    set /p "DB_PASS=Please enter db password: "

    set /p "PEM_FILE=Please enter the PEM file path: "

    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    
    set /p "SERVER_IP_home=Please enter the server IP [default: dev]: "

) else (

    set "GET_OLD=n"
)

if "!DB_PASS!"==""          set         "DB_PASS=Learnovia_2025*modern2025"
if "!PEM_FILE!"==""         set         "PEM_FILE=D:\learnovia.pem"
if "!SERVER_USER!"==""      set         "SERVER_USER=ubuntu"
if "!SERVER_IP_home!"==""   set         "SERVER_IP_home=dev"

set "SERVER_IP_home=%SERVER_IP_home%.learnovia.com"
set "SERVER_IP_target=%SERVER_IP_target%.learnovia.com"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'"
echo.
:: Prompt for front destination
set /p "DB=Please enter the database name: "

if "%DB%"=="" (
    echo "Database name is required"
    pause
)
set /p "DBName=edit db sql file name? [skip to use default]: "

if "%DBName%"=="" (
    set "DBName=%DB%"
)

for /f "tokens=2-3 delims=/- " %%a in ("%date%") do set "DBName=%DBName%_%%a_%%b"
echo %DBName%

pause

if "!GET_OLD!"=="n" (
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mkdir -p /tmp/scripts; rm -rf /tmp/scripts/*"
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mysqldump -u root -p%DB_PASS% --ignore-table=%DB%.audit_logs --ignore-table=%DB%.logs %DB% > /tmp/scripts/%DBName%.sql"
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mysqldump -u root -p%DB_PASS% --no-data %DB% jobs failed_jobs > /tmp/scripts/jobs.sql"
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "cat /tmp/scripts/jobs.sql >> /tmp/scripts/%DBName%.sql"

    if errorlevel 1 (
        echo "Error dumping %DB% database"
        pause
    )
    echo.
    echo %DB% database dumped successfully
    echo.
)
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "mkdir -p /tmp/scripts"

echo copying %DBName%.sql to %SERVER_IP_home%
echo.

ssh -t -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "rsync -av --progress -e 'ssh -i /home/ubuntu/learnovia.pem -o StrictHostKeyChecking=no' %SERVER_USER%@%SERVER_IP_target%:/tmp/scripts/%DBName%.sql /tmp/scripts/"

if errorlevel 1 (
    echo "Error copying %DBName%.sql to %SERVER_IP_home%"
    pause
)

echo %DBName%.sql copied successfully
echo.
set DB=%DBName%
echo creating %DB% database
echo.

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "mysql -u root -p%DB_PASS% -e 'DROP DATABASE IF EXISTS %DB%; CREATE DATABASE %DB%;'"
if errorlevel 1 (
    echo "Error importing %DB%.sql to %SERVER_IP_home%"
    pause
)
echo.

echo importing %DB%.sql to %DB% database
ssh -t -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "pv /tmp/scripts/%DB%.sql | mysql -u root -p%DB_PASS% %DB%"

@REM ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "rm /tmp/scripts/%DBName%.sql"

if errorlevel 1 (
    echo "Error copying %DB%.sql to %SERVER_IP_home%"
    pause
)

echo.
echo %DB%.sql imported successfully
echo.

if "!GET_OLD!"=="y" (
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "rm /tmp/scripts/%DBName%.sql"
)
pause
endlocal