#!/bin/bash
#
# This script starts the GigaSpaces JMX FocalServer

. `dirname $0`/setenv.sh

export CLASSPATH=${JSHOMEDIR}/lib/ServiceGrid/focalserver.jar:${JSHOMEDIR}/lib/ServiceGrid/gs-boot.jar:${SPRING_JARS}:${JSHOMEDIR}/lib/common/commons-logging.jar:${JSHOMEDIR}/lib/jini/jsk-lib.jar:${JSHOMEDIR}/lib/jini/jsk-platform.jar:${JMX_JARS}
"$JAVACMD" ${GS_LOGGING_CONFIG_FILE_PROP} -cp ${CLASSPATH} -Djava.security.policy=${POLICY} com.gigaspaces.jmx.focalserver.FocalServer ${JSHOMEDIR}/config/tools/focalserver.xml

