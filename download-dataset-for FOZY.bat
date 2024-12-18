@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Prompt for front destination
if "%~1"=="" (
    set /p "DATASET_NAME=Please enter the dataset name: "
) else (
    set "DATASET_NAME=%~1"
)

:: Prompt for front destination
if "%~2"=="" (
    set /p "SERVER_IP=server ip: "
) else (
    set "SERVER_IP=%~2"
)

:: Prompt for front destination
if "%~3"=="" (
    set /p "DESTINATION_PATH=destination path [D:\...]: "
) else (
    set "DESTINATION_PATH=%~3"
)

:: Create a new file
echo -----BEGIN RSA PRIVATE KEY----- > testfile.pem
echo MIIEowIBAAKCAQEArMIjS9uOYVxcjhj9fhKJSdKt3WmkVyMpPRFnkjtLUlyIGYlz >> testfile.pem
echo wwzKjRccaVl233fmesJjMrBkVIMwSHFcfI4iLIrt2+tCYZC6ShrRNog3HtGFgJbx >> testfile.pem
echo r9ApWYesLyrh8nM+1yJ+fSd6CxXssFlHZkaRr/KSblIiUfgibxPAEgkV2mTcDJdH >> testfile.pem
echo 39SI0zjBPIpVpl6b1gO+ZrLNvLb0OPK0h8jDL19sEjYFDEFxQz7QhoqbmOKEfDH3 >> testfile.pem
echo NK6Ex384W0jbS4jF9CQGRJe96ztxRz8kg56FzT1XYLkgeL9mlucUVE/3JQ6NSvvc >> testfile.pem
echo s0Q+rlQDSspqDJ++zxbPVtkBm2bO8zwmcp5nzwIDAQABAoIBAQCJwcjpfWr8oey/ >> testfile.pem
echo 9pd0h41oC5JOoyXDwirpIk7HYXa/dz+jtWJU34dImGw0aX2L1o03yHfXfKaUaYP/ >> testfile.pem
echo 0D1iqOgBQstG+UMWj5Ss8NNxO49QiNx+3F5exouic7hOaFCBx3oNjNj2LZt46YOy >> testfile.pem
echo X466tH0Jo1E2nVH2sPmsP0CCYTJG0aTgtFCEZVqOz+Gl7AfgnoFQkYHGoyRaldri >> testfile.pem
echo oM6QTFfRjsY365oLHP0+z8l6GQJc10jtM4J+3+w7SonrEUjq7bIBcn3TM1I7ZWsz >> testfile.pem
echo hQ9Wl+q5Gv5JTnHfz7rDYsNJQP7EoI83VH3lXrJusEd368mPU3SkqIPsyfVOk3+V >> testfile.pem
echo QzyCMa9xAoGBANYbdh1LQUgb+HdeEvbAKfLswbFqg4chYPyyD8Siwt5/ok868EBP >> testfile.pem
echo MB3FPKXDQEuDlQ7s4Sf/PXztPEGQeHxZs+gS1UYVWUcEUYS66r3HHO/Mc+E5XFB9 >> testfile.pem
echo T9tMoGvbwWqD5EDi1jdVsVxzAFKXyt0GqrerUsBbcy4Kby4qUmHr9L8HAoGBAM6P >> testfile.pem
echo hwD8s772t1vDzKmdlzn3LlExjmD3yFqG3Q2GtZBwg3OQTmexx+1wZRbrO1IT5LtF >> testfile.pem
echo QVxHbCpvqt+upUM41HchMFfiJx2ApVHr9Ju94ulM0hsUurMZKvCxNFaxO7Am1rfO >> testfile.pem
echo VHsqAeODaFAZ6I3bAWWvAo7SQl1LfYSYFsNeKhb5AoGAZSAvV4K14MMlRevu9RCq >> testfile.pem
echo P4zHp25xlR+U2YWYoP1nIQQTu2xREW7VgRopnPltor0RaC1F40hQ2HKMpUMBRWpw >> testfile.pem
echo 6MoMZb+rnTlS72gBe4VSC4j7qoMXMQUe9KtqkccHwbFt25/IIfadgNbobho3vNFr >> testfile.pem
echo TLjkquoGqtZO0PU4V/vEa30CgYADKhe7YCOwzT7J3RoJjyx96td+zu+LdMBRArfo >> testfile.pem
echo OSQW7mJVJuTMmeCiNpKV40ypWTyr0cfKjh2OGN/ZRWequ/glSxDeh8xpm0rtElxQ >> testfile.pem
echo 9nu/bznYyFyD2eLahRx0J4rui+nGLxcEPASDY8P5VixF4BEJacD0RyxVGY72tQ3E >> testfile.pem
echo OHEUoQKBgDJY61hBnT8DsXUU7mtKfCECMadArbuCDtGV9in+FHoP6gM0rLL026Fk >> testfile.pem
echo /DSBwOc7En4MRHsdhdyGeXjjR2rZ/cIv70N4WqbUE8W6d57fujKhr9APzyyLFb7y >> testfile.pem
echo zvVxsKfGZSI0ZQFLfwS/1P28+hzjh5uHIDBEBzo+yK8Nl1DtgimR >> testfile.pem
echo -----END RSA PRIVATE KEY----- >> testfile.pem

:: Append /dist to the upload destination
:: set "PROJECT_PATH=/"
set PEM_FILE="testfile.pem"
set SERVER_USER="ubuntu"
:: Set file permissions
:: Grant read and write permissions to the current user
icacls testfile.pem /grant "%username%":RW
===============================================================================
echo "Starting download dataset..."
scp -i %PEM_FILE% %SERVER_USER%@%SERVER_IP%:/home/ubuntu/%DATASET_NAME% %DESTINATION_PATH%/
pause
endlocal