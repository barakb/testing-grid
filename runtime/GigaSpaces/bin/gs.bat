@echo off
rem This script provides the command and control utility for the 
rem GigaSpaces Technologies Inc. Service Grid

rem Use local variables
setlocal

@call %~dp0\setenv.bat

rem Set local variables
set SERVICE_GRID_LIB=%JSHOMEDIR%\lib\ServiceGrid
set JINI_LIB=%JSHOMEDIR%\lib\jini

rem set booclasspath 
set bootclasspath=-Xbootclasspath/p:%XML_JARS%


rem Find the jars to use
if exist "%SERVICE_GRID_LIB%\gs-admin.jar" goto setgsadmin
if not exist "%SERVICE_GRID_LIB%\gs-admin.jar" goto systemFailure
set gsadmin=%SERVICE_GRID_LIB%\gs-admin.jar
goto checkgslib
:setgsadmin
set gsadmin=%SERVICE_GRID_LIB%\gs-admin.jar

:checkgslib
if exist "%SERVICE_GRID_LIB%\gs-lib.jar" goto setgslib
if not exist "%SERVICE_GRID_LIB%\gs-lib.jar" goto systemFailure
set gslib=%SERVICE_GRID_LIB%\gs-lib.jar
goto checkgsboot
:setgslib
set gslib=%SERVICE_GRID_LIB%\gs-lib.jar

:checkgsboot
if exist "%SERVICE_GRID_LIB%\gs-boot.jar" goto setgsboot
if not exist "%SERVICE_GRID_LIB%\gs-boot.jar" goto systemFailure
set gsboot=%SERVICE_GRID_LIB%\gs-boot.jar
goto jarsfound
:setgsboot
set gsboot=%SERVICE_GRID_LIB%\gs-boot.jar

:jarsfound

rem Parse command line
if "%1"=="" goto interactive
if "%1"=="start" goto start

:interactive
set cliExt=%JSHOMEDIR%\config\tools\gs_cli.config
set command_line=%*
set launchTarget=com.gigaspaces.admin.cli.GS
set classpath=-cp %JSHOMEDIR%;%gsadmin%;%JSHOMEDIR%/lib/JSpaces.jar;%JSHOMEDIR%/lib;%JSHOMEDIR%/lib/jini/jsk-lib.jar;%JSHOMEDIR%/lib/jini/jsk-platform.jar;%OPENSPACES_JARS%;%SPRING_JARS%;%COMMON_JARS%

set COMMAND=%JAVACMD% %bootclasspath% %classpath% %JAVA_OPTIONS% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% -Dcom.gs.logging.debug=false -Dhandlers=java.util.logging.FileHandler %GS_LOGGING_CONFIG_FILE_PROP% %launchTarget% %cliExt% %command_line%

echo.
echo Starting with line:
echo %COMMAND%
echo.
%COMMAND%
goto end

:start

rem Slurp the command line arguments. This loop allows for an unlimited number
rem of arguments (up to the command line limit, anyway).
shift
:setupCommandLine
if "%1"=="" goto commandLineParsed
if "%1"=="startGSC" goto addGSC
if "%1"=="startGSM" goto addGSM
if "%1"=="startGS" goto addGS
if "%1"=="startLH" goto addLH
if "%1"=="startTM" goto addTM
if "%1"=="noJMX" goto noJMX
if "%1"=="noHTTP" goto noHTTP

if "%options%"=="" goto addOptionsolo
   set options=%options% %1
   shift
   goto setupCommandLine
:addOptionsolo
   set options=%1
   shift
   goto setupCommandLine

rem If we've fallen through to here, we are done with the 
rem "startXXX" directives
goto commandLineParsed

:addGSC
    if "%services%"=="" goto addGSCsolo
    set services=%services%,GSC
    shift
    goto setupCommandLine

:addGSCsolo
    set services=GSC
    shift
    goto setupCommandLine

:addGSM
    if "%services%"=="" goto addGSMsolo
    set services=%services%,GSM
    shift
    goto setupCommandLine

:addGSMsolo
    set services=GSM
    shift
    goto setupCommandLine

:addGS
    if "%services%"=="" goto addGSsolo
    set services=%services%,GS
    shift
    goto setupCommandLine

:addGSsolo
    set services=GS
    shift
    goto setupCommandLine

:addLH
    if "%services%"=="" goto addLHsolo
    set services=%services%,LH
    shift
    goto setupCommandLine

:addLHsolo
    set services=LH
    shift
    goto setupCommandLine

:addTM
    if "%services%"=="" goto addTMsolo
    set services=%services%,TM
    shift
    goto setupCommandLine

:addTMsolo
    set services=TM
    shift
    goto setupCommandLine

:noJMX
    if "%services%"=="" goto noJMXsolo
    set services=%services%,NO_JMX
    shift
    goto setupCommandLine

:noJMXsolo
    set services=NO_JMX
    shift
    goto setupCommandLine

:noHTTP
    if "%services%"=="" goto noHTTPsolo
    set services=%services%,NO_HTTP
    shift
    goto setupCommandLine

:noHTTPsolo
    set services=NO_HTTP
    shift
    goto setupCommandLine

goto setupCommandLine

:commandLineParsed
set command_line=%options%
set startParm=com.gigaspaces.start.services=\"%services%\"
rem Set the path to include native library directory
set PATH=%PATH%;%SERVICE_GRID_LIB%\native
set launchTarget=com.gigaspaces.start.SystemBoot
set classpath=-cp %JDBC_JARS%;%JSHOMEDIR%;%JMX_JARS%;%gsboot%;%JSHOMEDIR%/lib/jini/start.jar

set COMMAND=%JAVACMD% %bootclasspath% %classpath% %JAVA_OPTIONS% %RMI_OPTIONS% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% -Dcom.gs.logging.debug=false %GS_LOGGING_CONFIG_FILE_PROP%  %launchTarget% %startParm% %command_line%

echo.
echo Starting with line:
echo %COMMAND%
echo.
%COMMAND%

goto end

:systemFailure
echo "Cannot locate system jars in the expected directory structure, exiting"

:end
endlocal
title Command Prompt
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
exit /B 0
