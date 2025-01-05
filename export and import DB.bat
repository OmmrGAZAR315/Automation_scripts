@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

set /p "SERVER_IP_target=Please enter the server DOMAIN: "

:: prompt for config
set /p "CUSTOM=DO YOU WANT TO USE CONFIG? [y/n]: "
if "!CUSTOM!"=="" set "CUSTOM=n"

if /I "!CUSTOM!" == "y" (
    set /p "DB_PASS=Please enter db password: "

    set /p "PEM_FILE=Please enter the PEM file path: "

    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "

) else (

    if "!DB_PASS!"=="" set "DB_PASS=Learnovia_2025*modern2025"
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
)


set "SERVER_IP_home=dev.learnovia.com"
set "SERVER_IP_target=%SERVER_IP_target%.learnovia.com"
===============================================================================

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mysql -u root -p%DB_PASS% -e 'SHOW DATABASES;'"
echo.
:: Prompt for front destination
set /p "DB=Please enter the database name: "

if "%DB%"=="" (
    echo "Database name is required"
    pause
    exit
)
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mkdir -p /tmp/scripts"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_target% "mysqldump -u root -p%DB_PASS% --ignore-table=%DB%.audit_logs --ignore-table=%DB%.logs %DB% > /tmp/scripts/%DB%.sql"
if errorlevel 1 (
    echo "Error dumping %DB% database"
    pause
    exit
)
echo.
echo %DB% database dumped successfully
echo.

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "mkdir -p /tmp/scripts"

echo copying %DB%.sql to %SERVER_IP_home%
echo.

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "scp -o StrictHostKeyChecking=no -i /home/ubuntu/learnovia.pem %SERVER_USER%@%SERVER_IP_target%:/tmp/scripts/%DB%.sql /tmp/scripts/"
if errorlevel 1 (
    echo "Error copying %DB%.sql to %SERVER_IP_home%"
    pause
    exit
)

echo %DB%.sql copied successfully
echo.

echo creating %DB% database
echo.

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "mysql -u root -p%DB_PASS% -e 'CREATE DATABASE %DB%;'"
if errorlevel 1 (
    echo "Error copying %DB%.sql to %SERVER_IP_home%"
    pause
    exit
)
echo.

echo importing %DB%.sql to %DB% database
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP_home% "mysql -u root -p%DB_PASS% %DB% < /tmp/scripts/%DB%.sql"
if errorlevel 1 (
    echo "Error copying %DB%.sql to %SERVER_IP_home%"
    pause
    exit
)
echo.
echo %DB%.sql imported successfully
echo.

pause
endlocal