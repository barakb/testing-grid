@echo off
@rem This script starts the GigaSpaces JMX FocalServer

rem Use local variables
setlocal

@call %~dp0\setenv.bat

rem Set local variables
set SERVICE_GRID_LIB=%JSHOMEDIR%\lib\ServiceGrid
set JINI_LIB=%JSHOMEDIR%\lib\jini

set CLASSPATH=%SERVICE_GRID_LIB%/focalserver.jar;%SPRING_JARS%;%SERVICE_GRID_LIB%/gs-boot.jar;%JSHOMEDIR%/lib/common/commons-logging.jar;%JSHOMEDIR%/lib/jini/jsk-lib.jar;%JSHOMEDIR%/lib/jini/jsk-platform.jar;%JMX_JARS%
%JAVACMD% %GS_LOGGING_CONFIG_FILE_PROP% -cp %CLASSPATH% -Djava.security.policy=%POLICY% com.gigaspaces.jmx.focalserver.FocalServer %JSHOMEDIR%/config/tools/focalserver.xml

endlocal
