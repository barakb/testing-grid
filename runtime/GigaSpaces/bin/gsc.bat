@echo off
rem This script is a wrapper around the "gs" script, and provides the command line instruction
rem to start the GigaSpaces Grid Service Container
rem
title GigaSpaces Technologies Service Grid : GSC
set command_line=%*
call %~dp0\gs.bat start startGSC %command_line%
