#!/bin/bash

SELECTED_BUILD_DIR=/home/xap/testing-grid/local-builds/build_12588-2602

while true; do
    name=$(date +%y-%m-%d-%H-%M)
    logdir=logs/${name}
    mkdir -p -v ${logdir}
    echo "killing all java"
    killall -s 9 -v java 
    
    echo "redirecting output to ${logdir}"
    echo "-- starting space --"
    ./startTGrid.sh &> ${logdir}/space.log &
    echo "-- waiting 10 sec  --"
    sleep 10
    echo "-- starting agents --"
    ./run-agents.sh 20
    sleep 10
    echo "-- submitting suite, logs at ${logdir}/submitter.log--"
    ./startSubmitter.sh ${SELECTED_BUILD_DIR}/QA/JSpacesTestSuite.jar &> ${logdir}/submitter.log
     echo "-- mv status dir from ${SELECTED_BUILD_DIR}/QA/status to ${SELECTED_BUILD_DIR}/QA/status_${name} --"
     mv -vf ${SELECTED_BUILD_DIR}/QA/status ${SELECTED_BUILD_DIR}/QA/status_${name}
done