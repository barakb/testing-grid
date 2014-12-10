@echo off
rem This script is a wrapper around the "gs" script, and provides the command line instruction
rem to start the GigaSpaces Grid Service Monitor and autonomous Lookup service
title GigaSpaces Technologies Service Grid : GSM
set command_line=%*
call %~dp0gs.bat start startLH startGSM %command_line%
