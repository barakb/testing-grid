#!/bin/bash
#
# This script is a wrapper around the "gs" script, and provides the command line instruction
# to start the GigaSpaces Grid Service Container, Grid Service Monitor  and autonomous 
# Lookup service

command_line=$*
services="com.gigaspaces.start.services=\"LH,GSC,GSM\""

`dirname $0`/gs.sh start $services $command_line

