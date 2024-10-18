@echo off
setlocal


:: Prompt for file path if not provided
if "%~1"=="" (
    set /p "FILE_PATH=Please enter the file path: "
) else (
    set "FILE_PATH=%~1"
)


:: Prompt for front destination
if "%~2"=="" (
    set /p "UPLOAD_DESTINATION=Please enter the front project path [default: /schools/SCHOOL_NAME/learnovia-frontend]: "
) else (
    set "UPLOAD_DESTINATION=%~2"
)
    
:: Append /dist to the upload destination
set "UPLOAD_DESTINATION=%UPLOAD_DESTINATION%/dist"


set "PEM_FILE=%~3"
if "%PEM_FILE%"=="" (
    set /p "PEM_FILE=Please enter the PEM file path: "
    if "%PEM_FILE%"=="" set "PEM_FILE=D:\learnovia.pem"
)


:: Set default values if not provided
set "SERVER_USER=%~4"
if "%SERVER_USER%"=="" (
    set /p "SERVER_USER=Please enter the server username [default: ubuntu]: "
    if "%SERVER_USER%"=="" set "SERVER_USER=ubuntu"
)


set "SERVER_IP=%~5"
if "%SERVER_IP%"=="" (
    set /p "SERVER_IP=Please enter the server IP [default: 98.81.160.170]: "
    if "%SERVER_IP%"=="" set "SERVER_IP=98.81.160.170"
)


:: Extract the file name from the file path
for %%F in ("%FILE_PATH%") do (
    set "FILE_NAME=%%~nxF"
    set "ARCHIVE_NAME=%%~xF"  :: Get the file extension
)


:: Upload the file using SCP
 echo Uploading "%FILE_PATH%" to %SERVER_USER%@%SERVER_IP%:%UPLOAD_DESTINATION%/
 scp -i D:\learnovia.pem "%FILE_PATH%" %SERVER_USER%@%SERVER_IP%:%UPLOAD_DESTINATION%/


:: Create a temporary directory on the server
ssh -i D:\learnovia.pem %SERVER_USER%@%SERVER_IP% "mkdir -p %UPLOAD_DESTINATION%/tmp/"

:: Check file extension and unarchive accordingly
if /i "%ARCHIVE_NAME%"==".rar" (
    echo Extracting RAR file...unrar x %UPLOAD_DESTINATION%/%FILE_NAME% %UPLOAD_DESTINATION%/tmp/
    ssh -i D:\learnovia.pem %SERVER_USER%@%SERVER_IP% "unrar x %UPLOAD_DESTINATION%/%FILE_NAME% %UPLOAD_DESTINATION%/tmp/ > /dev/null 2>&1"
) else if /i "%ARCHIVE_NAME%"==".zip" (
    echo Extracting ZIP file..."unzip %UPLOAD_DESTINATION%/%FILE_NAME% -d %UPLOAD_DESTINATION%/tmp/"
    ssh -i D:\learnovia.pem %SERVER_USER%@%SERVER_IP% "unzip %UPLOAD_DESTINATION%/%FILE_NAME% -d %UPLOAD_DESTINATION%/tmp/ > /dev/null 2>&1"
) else (
    echo Unsupported file format: %ARCHIVE_NAME%
    exit /b 1
)


:: Remove old directories on the server
ssh -i D:\learnovia.pem %SERVER_USER%@%SERVER_IP% "rm -rf %UPLOAD_DESTINATION%/learnovia"


:: Move the extracted folder to the final destination
ssh -i D:\learnovia.pem %SERVER_USER%@%SERVER_IP% "mv %UPLOAD_DESTINATION%/tmp/learnoviaFront %UPLOAD_DESTINATION%/learnovia"

ssh -i D:\learnovia.pem %SERVER_USER%@%SERVER_IP% "rm -rf %UPLOAD_DESTINATION%/tmp"


echo Upload and extraction completed successfully.
pause
endlocal