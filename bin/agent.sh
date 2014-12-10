#!/bin/bash

. set-tgrid-env.sh 

echo Starting TGrid Agent..
ulimit -a
ulimit -c unlimited
ulimit -a

#REMOTE_DEBUG="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8000"

export AGENTS_TYPE=$1

echo ${TGRID_EXEC_CMD} ${REMOTE_DEBUG} -D${AGENT_REGEX_PROPERTY}=${AGENT_REGEX_VALUE} com.gigaspaces.tgrid.agent.Agent ${AGENTS_TYPE}
${TGRID_EXEC_CMD} ${REMOTE_DEBUG} -D${AGENT_REGEX_PROPERTY}=${AGENT_REGEX_VALUE} com.gigaspaces.tgrid.agent.Agent ${AGENTS_TYPE}
