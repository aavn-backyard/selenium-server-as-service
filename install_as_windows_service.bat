@echo off

:: This batch program will install SeleniumServer as a Windows service
:: by using NSSM (Non Sucking Service Manager)
:: You only need to submit a port for the SeleniumServer to run.

echo Installing SeleniumServer as a Windows Service

set /p port=Enter the port: 
set java=%JAVA_HOME%\bin\java.exe
set current_selenium_server_jar=%cd%\selenium-server-standalone-2.43.1.jar
set service_name=SeleniumServer_%port%

rem Validate port
set "var="&for /f "delims=0123456789" %%i in ("%port%") do set var=%%i
if defined var (goto invalid-port)

if %port% lss 0 goto invalid-port
if %port% GTR 65535 goto invalid-port
)

rem Validate JDK
if not exist %java% goto missing-jdk

rem Validate SeleniumServer
if not exist %current_selenium_server_jar% goto selenium-server-jar-missing

rem Use NSSM to install SeleniumServer command as a Windows service
nssm-x64.exe install %service_name% "%java%" "-jar %current_selenium_server_jar% -port %port%"
goto finish

:missing-jdk
echo ERROR! Make sure you have JDK installed.
goto finish


:selenium-server-jar-missing
echo ERROR! The selenium-server.jar is missing.
goto finish

:invalid-port
echo ERROR! Port %port% is invalid.
goto finish

:finish
pause