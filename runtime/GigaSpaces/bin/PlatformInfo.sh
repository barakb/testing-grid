#!/bin/sh

VERBOSE=true
. `dirname $0`/setenv.sh

java -classpath "${JSHOMEDIR}/lib/JSpaces.jar"  com.gigaspaces.admin.cli.RuntimeInfo
