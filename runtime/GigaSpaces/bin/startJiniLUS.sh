#!/bin/sh
echo Starting a Reggie Jini Lookup Service instance
command_line=$*
services="com.gigaspaces.start.services=\"LH\""

`dirname $0`/gs.sh start $services $command_line
