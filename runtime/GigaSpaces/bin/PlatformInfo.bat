@title Platform Info

@set VERBOSE=true
@call %~dp0\setenv.bat

@java -classpath %JSHOMEDIR%/lib/JSpaces.jar com.gigaspaces.admin.cli.RuntimeInfo 
ECHO Press Enter to exit . . .
SET /P =
