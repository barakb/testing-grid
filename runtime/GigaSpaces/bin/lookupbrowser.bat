@call %~dp0\setenv.bat

@%JAVACMD% -Djava.security.policy=%POLICY% -classpath "%JSHOMEDIR%\lib\jini\jsk-lib.jar;%JSHOMEDIR%\lib\jini\jsk-platform.jar;%JSHOMEDIR%\lib\jini\reggie.jar;%JSHOMEDIR%\lib\jini\browser.jar;%JSHOMEDIR%\lib\JSpaces.jar;%JSHOMEDIR%\lib\ServiceGrid\gs-boot.jar" com.sun.jini.example.browser.Browser
