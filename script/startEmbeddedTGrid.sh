#!/bin/bash

echo Starting Embedded TGrid...

. set-build-env.sh

#build number of build located under TGridRootDir/local-builds/buildNumXXX
BUILD_NUM=$1
if [ "${BUILD_NUM}" = "" ]
  then
    echo Error - Missing argument: Build Number.
    echo ""
    exit 1
fi

#assume that build already locates under TGridRootDir/local-builds, start regression with suite jar under BuildXXX/QA directory
SUITE_JAR_PATH=${TGRID_ROOT_DIR}/local-builds/build_${BUILD_NUM}/QA/JSpacesTestSuite.jar

#set the suite manifest overrides
MANIFEST_OVERRIDES=-Dtgrid-suite-reporters=com.gigaspaces.tgrid.report.ConsoleReporter

#REMOTE_DEBUG="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000"

#init command line
CMD="${JAVACMD} -Xmx512m ${REMOTE_DEBUG} ${TGRID_JVM_PROPERTIES} ${MANIFEST_OVERRIDES} -cp ${TGRID_CLASSPATH}:${SUITE_JAR_PATH} com.gigaspaces.tgrid.cli.EmbeddedTGrid "/./TestingGrid?properties=gs" ${SUITE_JAR_PATH}" 

echo $CMD

#start
${CMD}
