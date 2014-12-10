@title=Jini Transaction Manager - Mahalo
@echo Starting a Mahalo Jini Transaction Manager instance

set command_line=%*
call %~dp0\gs.bat start startTM %command_line%
