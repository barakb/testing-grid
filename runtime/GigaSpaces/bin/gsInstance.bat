@echo off
rem This script provides the command and control utility for the 
rem GigaSpaces Technologies gsInstance script.
rem The gsInstance script starts a space using the SpaceFinder utility.

rem Usage: If no args are passed, it will use the default Space URL.
rem Arguments can be passed through a command line:

rem arg 1  - the space URL (enclosed by ""), will be set into the SPACE_URL variable.
rem If "" is passed the system will use the default space URL.

rem arg 2 - a user defined path which will be appended to the beginning of the used classpath.
rem The prefixed classpath needs to be enclosed by "" and the value will be set into the APPEND_TO_CLASSPATH_ARG variable

rem arg 3  - Any additional command line arguments such as system properties. 
rem The argument needs to be enclosed by "" and the value will be set into the APPEND_ADDITIONAL_ARG variable.

rem E.g. gsInstance "/./newSpace?schema=persistent" "../../classes" "-DmyOwnSysProp=value -DmyOwnSysProp2=value"
rem Or gsInstance "" "" "-DmyOwnSysProp=value -DmyOwnSysProp2=value"
rem In this case it will use the default space URL and classpath and just append new sys props.

@rem The call to setenv.bat can be commented out if necessary.
@call "%~dp0\setenv.bat"
rem Use local variables
rem setlocal

rem set booclasspath
set bootclasspath=-Xbootclasspath/p:%XML_JARS%

@echo Starting a Space Instance
@set JSHOMEDIR=%~dp0\..

if %LOOKUPGROUPS% == ""  (
  set LOOKUPGROUPS="gigaspaces-7.0.0-XAPPremium-ga"
)
set LOOKUP_GROUPS_PROP=-Dcom.gs.jini_lus.groups=%LOOKUPGROUPS%

if "%LOOKUPLOCATORS%" == ""  (
set LOOKUPLOCATORS=
)
set LOOKUP_LOCATORS_PROP=-Dcom.gs.jini_lus.locators=%LOOKUPLOCATORS%

set SPACE_URL=%1
if "%~1"=="" (
  set SPACE_URL="/./mySpace?schema=default&properties=gs&groups=%LOOKUPGROUPS%"
)
echo Setting space url to %SPACE_URL%

set TITLE="Space Instance ["%SPACE_URL%"] started on [%computername%]"
@title %TITLE%

rem The user may append any user defined directories to the classpath.
if NOT "%~2" == "" (
  set APPEND_TO_CLASSPATH_ARG="%~2"
)

rem The user may append any additional properties (such as system properties like -Dxxx etc.) to the command line.
if NOT "%~3" == "" (
  set APPEND_ADDITIONAL_ARG="%~3"
)

set COMMAND_LINE=%JAVACMD% %JAVA_OPTIONS% %bootclasspath% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% %RMI_OPTIONS% "-Dcom.gs.home=%JSHOMEDIR%" -Dcom.gs.start-embedded-lus=true -Dcom.gs.start-embedded-mahalo=false -Dcom.gs.logging.debug=false %GS_LOGGING_CONFIG_FILE_PROP% %APPEND_ADDITIONAL_ARG% -classpath %PRE_CLASSPATH%;%APPEND_TO_CLASSPATH_ARG%;%JDBC_JARS%;%SIGAR_JARS%;%GS_JARS%;%POST_CLASSPATH% com.j_spaces.core.client.SpaceFinder %SPACE_URL%

echo.
echo.
echo Starting gsInstance with line:
echo %COMMAND_LINE%
echo.

%COMMAND_LINE%
goto end

:end
endlocal
title Command Prompt
set TITLE=
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
exit /B 0
