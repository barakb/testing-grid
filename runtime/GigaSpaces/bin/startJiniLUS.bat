@title=Jini Lookup Service - Reggie
@echo Starting a Reggie Jini Lookup Service instance

set command_line=%*
call "%~dp0\gs.bat" start startLH %command_line%
