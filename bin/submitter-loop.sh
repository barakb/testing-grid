#!/bin/bash -x


#BUILD=build_12588-2602
#BUILD=build_12588-2628
#BUILD=build_10811-443_9.7.1

#SELECTED_BUILD_DIR=/home/xap/testing-grid/local-builds/${BUILD}

while true; do
    ./clean-local-builds.sh
    ./copy-build.sh prefix 12588
    BUILD=$(head -n 1 build.txt)
    SELECTED_BUILD_DIR=/home/xap/testing-grid/local-builds/${BUILD}
    echo "Running build ${SELECTED_BUILD_DIR}"
    rm -rf /var/tmp/tgrid/QA/status/*
    name=$(date +%y_%m_%d_%H_%M)
    logdir=logs/${BUILD}/${name}
    mkdir -p -v ${logdir}
    echo "-- killing all java --"
    killall -s 9 -v java 
    echo "-- redirecting output to ${logdir} --"
    sleep 10
    echo "-- starting agents --"
    ./run-agents.sh 20
    sleep 10
    echo "-- submitting suite, logs at ${logdir}/submitter.log --"
    ./startSubmitter.sh ${SELECTED_BUILD_DIR}/QA/JSpacesTestSuite.jar ${BUILD}_${name} &> ${logdir}/submitter.log 
    echo "-- copy status dir from ${SELECTED_BUILD_DIR}/QA/status to ${SELECTED_BUILD_DIR}/QA/status_${name} --"
    cp -f ${SELECTED_BUILD_DIR}/QA/status ${SELECTED_BUILD_DIR}/QA/status_${name}
done
