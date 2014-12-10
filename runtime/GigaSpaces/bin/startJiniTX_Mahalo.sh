#!/bin/bash
echo Starting a Mahalo Jini Transaction Manager instance
command_line=$*
services="com.gigaspaces.start.services=\"TM\""

`dirname $0`/gs.sh start $services $command_line
