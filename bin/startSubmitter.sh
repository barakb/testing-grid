#!/bin/bash

echo Starting TestSuite Submitter...

. set-build-env.sh

#supplied suite-jar to run regression or get a list of local builds
SUITE_JAR_PATH=$1
HISTORY_BUILD_LIST=$2

#if SUITE_JAR_PATH is not defined show the list of available local regression builds under TestingGrid/local-builds directory
#if status directory of selected build is not empty press [y] to delete all results, otherwise [n]
if [ "${SUITE_JAR_PATH}" = "" ]
 then
   . list-builds.sh ${BUILDS_CACHE_REPOSITORY} ${HISTORY_BUILD_LIST}
   COUNT_DIR=`find ${SELECTED_BUILD_DIR}/QA/status | wc -l`
   if [ ${COUNT_DIR} -gt 1 ]
      then
         echo -n Status directory of ${SELECTED_BUILD_NAME} is not empty, do you want to delete all results [y/n]:
         read IS_DELETE
         if [ "${IS_DELETE}" = "y" ]
           then
             echo Deleting all status results...
             rm -rf ${SELECTED_BUILD_DIR}/QA/status/*
         fi
   fi
   SUITE_JAR_PATH="${SELECTED_BUILD_DIR}/QA/JSpacesTestSuite.jar"
fi

#REMOTE_DEBUG="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000"

#init command line
export LD_LIBRARY_PATH=/export/tgrid/TestingGrid1.5.0/libfdf:/usr/lib64:/usr/local/lib64:/export/utils/your-kit/yjp-6.0.14/lib:/usr/local/lib:/export/utils/lib
echo start submitter LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

if [ "$2" = "" ]
then
    CMD="${JAVACMD} -Xmx1524m ${REMOTE_DEBUG} ${TGRID_JVM_PROPERTIES} ${MANIFEST_OVERRIDES} -cp ${TGRID_CLASSPATH}:${SUITE_JAR_PATH} com.gigaspaces.tgrid.submission.TGridSubmitter ${SUITE_JAR_PATH}" 
else
    CMD="${JAVACMD} -Xmx1524m ${REMOTE_DEBUG} ${TGRID_JVM_PROPERTIES} ${MANIFEST_OVERRIDES} -DSuite-Version=Isolated_Regression_Report -DBuild-Version="$2" -cp ${TGRID_CLASSPATH}:${SUITE_JAR_PATH} com.gigaspaces.tgrid.submission.TGridSubmitter ${SUITE_JAR_PATH}" 
fi
#CMD="${JAVACMD} -Xmx1524m ${REMOTE_DEBUG} -Djava.library.path=/export/tgrid/TestingGrid1.5.0/libfdf ${TGRID_JVM_PROPERTIES} ${MANIFEST_OVERRIDES} -cp ${TGRID_CLASSPATH}:${SUITE_JAR_PATH} com.gigaspaces.tgrid.submission.TGridSubmitter ${SUITE_JAR_PATH}" 


echo $CMD

#start
${CMD}
