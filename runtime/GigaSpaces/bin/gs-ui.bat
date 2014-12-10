@echo off
rem This script provides startup for the GigaSpaces Management Center
title GigaSpaces Management Center

rem Use local variables
if "%OS%"=="Windows_NT" @setlocal
if "%OS%"=="WINNT" @setlocal

@call "%~dp0\setenv.bat"

set classpath=-cp %PRE_CLASSPATH%;%UI_JARS%;%JDBC_JARS%;%HIBERNATE_JARS%;%JMX_JARS%;%GS_JARS%;%SPRING_JARS%;%POST_CLASSPATH%

set bootclasspath=-Xbootclasspath/p:%XML_JARS%

set launchTarget=com.gigaspaces.admin.ui.MainUI
set config=config/tools/adminui.config

rem Set the path to include native library directory
set PATH=%PATH%;%JSHOMEDIR%\lib\platform\native

rem List of System properties which control several debugging and logging facilities such as:
rem UI, Jini services (Lookup Service, Tx Manager, HTTPD), cluster and non-server side configuration logging.
rem For a full list of properties please refer to the schema files or the product documentation.
set SYS_PROPS=-Dcom.gs.env.report=false -Dcom.gs.jini.useDefinedGroupOnly=false -Dcom.gs.browser.containername=mySpace_container -Dcom.gs.logging.debug=true -Dcom.gs.embeddedQP.enabled=true -Djava.protocol.handler.pkgs=net.jini.url

if "%command_line%" == "" goto noOverride
set parms=%config% %command_line%
goto startUI

:noOverride
set parms=%config%

:startUI
set COMMAND=%JAVAWCMD% %bootclasspath% %classpath% %JAVA_OPTIONS% %RMI_OPTIONS% %SYS_PROPS% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% %GS_LOGGING_CONFIG_FILE_PROP% %launchTarget% %parms%

echo.
echo Starting GigaSpaces Management Center:
echo %COMMAND%
echo.
@start "GigaSpaces Management Center" %COMMAND%

:end
title Command Prompt
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
exit /B 0

