#!/bin/bash

umask 000

##
# This script provides starting regression and submitting test-suite to the TGrid server.
# Wizard mode provides the following steps:
# 1. list available builds on build-server
# 2. Setup selected build from #case1
# 3. Submit test-suite to the TGrid server
# 4. Cleanup test enviroment with ${BUILD_CACHE_DIR}/QA/bin/cleanup-env.sh
# 
# Silent mode + dagent start:
# 1 arg [optional]: build-argument i.e: build_1804-01, or no args to get full list of available builds on build-server
# 2 arg [optional]: jdk version for XAP zip
# 3 arg [optional]: jdk order version for agents that defines in config-java
# 4 arg [optional]: machines list to run agents on i.e: 12-17 to run the supplied id machines
#
# @see dagent.sh
# @see setup-build.sh 
# @see startSubmitter.sh
# @author Igor Goldenberg
##

# if there are 4 arguments, start agents automatically. the first argument set the agent operation (2 - start agents, 3 - kill agents)

TARGET_JDK_ORDER=$3
TARGET_MACHINES=$4

echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

echo "> Clean pc-lab machines which are not part of this run"
 ./dagent.sh 3 ${TARGET_JDK_ORDER} 62,63,93,94

echo "> Clean target pc-lab machines"
if [ "$TARGET_MACHINES" != "" ]
then
 ./dagent.sh 3 ${TARGET_JDK_ORDER} ${TARGET_MACHINES} 
  sleep 5
fi

pdsh -w ssh:pc-lab[${TARGET_MACHINES}] "rm -rf /tmp/blobstore" &

echo "> Setup build"
. setup-build.sh $*

echo "> Kill automatically all ssh sessions on target machines"
 ./dagent.sh 4 ${TARGET_MACHINES}

sleep 15

echo "> Start all agents on target pc-lab machines"
if [ "$TARGET_MACHINES" != "" ]
then
 ./dagent.sh 2 ${TARGET_JDK_ORDER} ${TARGET_MACHINES} &
fi

chmod -R 777 ${BUILD_CACHE_DIR}

# temporary start submitter with target JVM in order to exclude tests of 1.5 from 1.4
if [ "${TARGET_JDK_ORDER}" != "" ]
 then
  . set-dagent-env.sh
  ${CONFIG_JAVA_SCRIPT} ${TARGET_JDK_ORDER}
fi

echo "> Submit supplied build to the TGrid"
# replace JAVA_HOME to original JAVA_HOME. Needed if agents jvm is not available on all machines, but on specific machines only.
${CONFIG_JAVA_SCRIPT} 20
. startSubmitter.sh ${BUILD_CACHE_DIR}/QA/${QA_TESTSUITE_FILENAME} 

echo "> Kill automatically all agents on target machines"
 ./dagent.sh 3 ${TARGET_JDK_ORDER} ${TARGET_MACHINES} &

echo "> Clean regression build"
. cleanup-env.sh

echo "> After cleanup. Killing procceses..."
./pkill.sh /export/utils/bin/pdsh
./pkill.sh remote-cmd-executor.sh

echo "> Process finished"
exit 0
