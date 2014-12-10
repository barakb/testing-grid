#!/bin/bash

. set-tgrid-env.sh 

# Initializing TGridRuntime 
JSHOMEDIR=${RUNTIME_HOMEDIR}; export JSHOMEDIR

LOOKUPGROUPS="tgrid"; export LOOKUPGROUPS

# start TGrid
${RUNTIME_HOMEDIR}/bin/gsInstance.sh "/./pc-lab148_TestingGrid?properties=gs" "${TGRID_CLASSPATH}"
