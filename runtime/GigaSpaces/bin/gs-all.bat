@echo off
rem This script is a wrapper around the "gs" script, and provides the command line instruction
rem to start the GigaSpaces Grid Service Container, Grid Service Monitor  and autonomous 
rem Lookup service
title GigaSpaces Technologies Service Grid : GSM,GSC
set command_line=%*
call %~dp0gs.bat start startLH startGSM startGSC %command_line%
