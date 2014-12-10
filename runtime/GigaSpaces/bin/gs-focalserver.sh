#!/bin/bash
#
# This script starts the GigaSpaces JMX FocalServer

. `dirname $0`/setenv.sh

export CLASSPATH=${SPRING_JARS}:${GS_JARS}:${JMX_JARS}
"$JAVACMD" ${GS_LOGGING_CONFIG_FILE_PROP} -cp ${CLASSPATH} -Djava.security.policy=${POLICY} com.gigaspaces.jmx.focalserver.FocalServer "config/tools/focalserver.xml"

