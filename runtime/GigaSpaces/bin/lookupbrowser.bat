@call "%~dp0\setenv.bat"

@%JAVACMD% -Djava.security.policy=%POLICY% -classpath %GS_JARS% com.sun.jini.example.browser.Browser
