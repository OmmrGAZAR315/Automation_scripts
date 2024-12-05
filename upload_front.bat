@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion


:: Prompt for file path if not provided
if "%~1"=="" (
    set /p "FILE_PATH=Please enter the file path: "
) else (
    set "FILE_PATH=%~1"
)


:: Prompt for front destination
if "%~2"=="" (
    set /p "UPLOAD_DESTINATION=Please enter the front project path [default: SCHOOL_NAME]: "
) else (
    set "UPLOAD_DESTINATION=%~2"
)
    
:: Append /dist to the upload destination
set "UPLOAD_DESTINATION=/schools/%UPLOAD_DESTINATION%/learnovia-frontend/dist"


set "PEM_FILE=%~3"
if not defined PEM_FILE (
    set /p "PEM_FILE=Please enter the PEM file path: "
    if "!PEM_FILE!"=="" set "PEM_FILE=D:\learnovia.pem"
)

REM Set SERVER_USER from the 4th argument
set "SERVER_USER=%~4"
if not defined SERVER_USER (
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    if "!SERVER_USER!"=="" set "SERVER_USER=ubuntu"
)

REM Set SERVER_IP from the 5th argument
set "SERVER_IP=%~5"
if not defined SERVER_IP (
    set /p "SERVER_IP=Please enter the server IP [default: 98.81.160.170]: "
    if "!SERVER_IP!"=="" set "SERVER_IP=dev.learnovia.com"
)

:: Append .learnovia.com to the server ip
set "SERVER_IP=%SERVER_IP%.learnovia.com"
===============================================================================

:: Extract the file name from the file path
for %%F in ("%FILE_PATH%") do (
    set "FILE_NAME=%%~nxF"
    set "ARCHIVE_NAME=%%~xF"  :: Get the file extension
)

ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo rm -rf %UPLOAD_DESTINATION%/"%ARCHIVE_NAME%"/"

:: Upload the file using SCP
echo Uploading "%FILE_PATH%" to %SERVER_USER%@%SERVER_IP%:%UPLOAD_DESTINATION%/
scp -i %PEM_FILE% "%FILE_PATH%" %SERVER_USER%@%SERVER_IP%:%UPLOAD_DESTINATION%/

:: Create a temporary directory on the server
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mkdir -p %UPLOAD_DESTINATION%/tmp/"

:: Check file extension and unarchive accordingly
if /i "%ARCHIVE_NAME%"==".rar" (
    echo Extracting RAR file...unrar x %UPLOAD_DESTINATION%/%FILE_NAME% %UPLOAD_DESTINATION%/tmp/
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "unrar x %UPLOAD_DESTINATION%/%FILE_NAME% %UPLOAD_DESTINATION%/tmp/ > /dev/null"
) else if /i "%ARCHIVE_NAME%"==".zip" (
    echo Extracting ZIP file..."unzip %UPLOAD_DESTINATION%/%FILE_NAME% -d %UPLOAD_DESTINATION%/tmp/"
    ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "unzip %UPLOAD_DESTINATION%/%FILE_NAME% -d %UPLOAD_DESTINATION%/tmp/  > /dev/null"
) else (
    echo Unsupported file format: %ARCHIVE_NAME%
    exit /b 1
)

echo Upload and extraction completed successfully.

:: rename old directories on the server
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mv %UPLOAD_DESTINATION%/learnovia %UPLOAD_DESTINATION%/learnovia_$(date \"+%%d-%%m-%%Y\")"


:: Restart Nginx
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "sudo systemctl restart nginx > /dev/null"

echo "old build is renamed"

:: Move the extracted folder to the final destination
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mv %UPLOAD_DESTINATION%/tmp/learnoviaFront %UPLOAD_DESTINATION%/learnovia"
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "rm -rf %UPLOAD_DESTINATION%/tmp"
:: Move uploaded file to tmp
ssh -i %PEM_FILE% %SERVER_USER%@%SERVER_IP% "mv %UPLOAD_DESTINATION%/%FILE_NAME% /tmp"

echo "the uploaded build is running..."
pause
endlocal