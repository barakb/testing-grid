#!/bin/bash

## 
# This script provides remote command execution receives from dagent.sh
# NOTE: All arguments sent by dagent.sh to remote-cmd-executor.sh should be
# coordicated with : case ${OPER_TYPE_AGENT} in
# All common functions/variables for both scripts locates in set-dagent-env.sh
#
# @set-dagent-env.sh
# @see dagent.sh
# @author Igor Goldenberg
##

# setup env variables and common functions
. set-dagent-env.sh

OPER_TYPE_TGRID_SERVER=$1
OPER_TYPE_AGENT=$2
JAVA_TYPE=$3
TGRID_ROOT_BIN_DIR=$4
export AGENT_REGEX_PROPERTY=$5
export AGENT_REGEX_VALUE=$6
export AGENTS_TYPE=$7

# calculate total running agents on this machine
echo Agent operation type: ${map_agent_opers[OPER_TYPE_AGENT-1]} 

# cd to TGrid directory
cd ${TGRID_ROOT_BIN_DIR}

# setup Agents
case ${OPER_TYPE_AGENT} in
   ${START_AGENTS_OPER_TYPE}) echo Starting agents...
      # setup JDK
      ${CONFIG_JAVA_SCRIPT} ${JAVA_TYPE}
      echo Setup JDK: ${JAVA_HOME}
      ./agent.sh ${AGENTS_TYPE} &
      calc_total_agents	
   ;;
   ${KILL_AGENTS_OPER_TYPE}) calc_total_agents 
      echo Kill all [${TOTAL_RUNNING_AGENTS}] agents...
      killall -9 java
      #./killTest.sh "com.gigaspaces.tgrid.agent.Agent"	
   ;;
esac

# calculate total running agents
calc_total_agents
echo ${TOTAL_RUNNING_AGENT_MSG} ${TOTAL_RUNNING_AGENTS} 
