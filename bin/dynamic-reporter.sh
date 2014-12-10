#!/bin/bash

TGRID_BIN_FOLDER=./../../../../bin/
CURRENT_DIR=`pwd`
TF_JAR_PATH=${CURRENT_DIR}/../lib/tf.jar

from=$1
to=$2
type=$3
pageName=$4


# setup classpath variables
cd ${TGRID_BIN_FOLDER}
. set-build-env.sh

cd ${CURRENT_DIR}

#init command line
CMD="${JAVACMD} -cp ${TGRID_CLASSPATH}:${TF_JAR_PATH} com.gigaspaces.framework.tgrid.report.DynamicReporter -from $from -to $to -type $type -pageName $pageName"

echo $CMD

#start
${CMD}