#!/bin/bash

## 
# This scripts provide wizard steps to start/kill TGrid Agents on desired machines.
# Available operations:
# 1. Get total running agents
# 2. Start agents with desired JDK vendor
# 3. Kill agents
# dagent.sh works via pdsh and delegets supplied commands to remote-cmd-executor.sh which physically performs the supplied operation.
# NOTE: all env variable locates in set-dagent-env.sh for both scripts, all dagent commands should be coordinated with remote-cmd-executor.sh so make sure all commands locates in set-dagent-env.sh
#
# Tip: If dagent receives all arguments the silent mode will be turn on without wizard.
# Silent usage: dagent.sh [1=get total agents, 2=start, 3=kill] [ config-java jvm orderID ] [target_machine]
# 
# Example usage to start agents on pc-lab7-25 with Sun JDK 1.4.2_12:
# dagent.sh 1 3 7-25
#
# @see config-java
# @see set-dagent-env.sh
# @see remote-cmd-executor.sh
# @author Igor Goldenberg
##

# setup env variables and common functions
. set-dagent-env.sh

#printf "\n"
#echo -e "\033[1mTGrid Server [default=1]:  \033[0m"
#echo 1. Leave running
#echo 2. Restart
#echo 3. Remove all pending tests
#echo 4. Kill tgrid processes 
#echo -n "> "
#read OPER_TYPE_TGRID_SERVER
if [ -z "${OPER_TYPE_TGRID_SERVER}" ]
 then 
  OPER_TYPE_TGRID_SERVER=${DEFAULT_OPER_TYPE_TGRID_SERVER}
fi

if [ "$1" -eq 4 ]
  then
    echo "killing tgrid processes."
    pdsh -w ssh:pc-lab[62,63,93,94] pkill -9 -u tgrid
    exit 0
fi

# start wizard steps only if $3 is empty, otherwise call perform silent mode directly to remote-executor.sh
if [ -z "$3" ]
 then
   clear
   echo -e '\E[37;44m'" \033[1m Welcome to distributed TGrid Agent wizard! \033[0m\n"
   echo -e "\033[1mEnter your operation 1-${#map_agent_opers[*]} [default=${DEFAULT_OPER_TYPE_AGENT}]:  \033[0m"
   show_agent_opers   
   echo -n "> "
   read OPER_TYPE_AGENT
   if [ -z "${OPER_TYPE_AGENT}" ]
     then
       OPER_TYPE_AGENT=${DEFAULT_OPER_TYPE_AGENT}
   fi

   # only if operation type is "Start Agent" show the jdk option
   if [ "${OPER_TYPE_AGENT}" = "${START_AGENTS_OPER_TYPE}" ]
   then
     ${CONFIG_JAVA_SCRIPT} $*
     JAVA_TYPE=${answer}
   fi

   printf "\n"
   echo -e "\033[1mEnter pc-lab machine numbers you want to start/kill agents [default=${DEFAULT_REMOTE_MACHINES}]:  \033[0m"
   echo Example: 20,21,22,23 or 20-23 
   echo NOTE: Input should be only pc-lab numbers without pc-lab prefix and with comma-separator or dash.
   echo -n "> "
   read REMOTE_MACHINES_WITHOUT_AGENT_INDEX 
   if [ -z "${REMOTE_MACHINES_WITHOUT_AGENT_INDEX}" ]
     then
       REMOTE_MACHINES_WITHOUT_AGENT_INDEX=${DEFAULT_REMOTE_MACHINES}
   fi

   printf "\n"
   echo -e "\033[1m**** SUMMARY ***  \033[0m"
   echo -e "\033[1mAgent operation: \033[0m ${map_agent_opers[OPER_TYPE_AGENT-1]}"
   echo -e "\033[1mpc-lab machines: \033[0m ${REMOTE_MACHINES_WITHOUT_AGENT_INDEX}"
   echo -en "Press \033[1m<Enter>\033[0m to start..."
   read
   printf "\n"
else
  OPER_TYPE_AGENT=$1
  JAVA_TYPE=$2
  REMOTE_MACHINES_WITHOUT_AGENT_INDEX=$3
fi

AGENTS_TYPE="regular"

if [ "${REMOTE_MACHINES}" != "" ]
then
    if [ "${REMOTE_MACHINES}" = "132,133" ] ; then
        echo "starting SSD agents"
        AGENTS_TYPE="ssd"
    fi
fi

# execute supplied remote commands on desired lab machines and calculate total active agents

if [ -n ${REMOTE_MACHINES_USING_AGENT_REGEX} ] 
then
	echo LALALALALALALALALALALALALALALALALALA
	 echo ${PDSH} -u 5 -f 100 -w ssh:pc-lab[${REMOTE_MACHINES_USING_AGENT_REGEX}] "${REMOTE_EXECUTOR_SCRIPT} ${OPER_TYPE_TGRID_SERVER} ${OPER_TYPE_AGENT} ${JAVA_TYPE} ${TGRID_ROOT_BIN_DIR} permutationIncludeRegex ${AGENT_REGEX_VALUE} ${AGENTS_TYPE} "
	total_agents=`${PDSH} -u 5 -f 100 -w ssh:pc-lab[${REMOTE_MACHINES_USING_AGENT_REGEX}] "${REMOTE_EXECUTOR_SCRIPT} ${OPER_TYPE_TGRID_SERVER} ${OPER_TYPE_AGENT} ${JAVA_TYPE} ${TGRID_ROOT_BIN_DIR} permutationIncludeRegex ${AGENT_REGEX_VALUE} ${AGENTS_TYPE} " | grep "${TOTAL_RUNNING_AGENT_MSG}" | awk -F: '{sum += $3}; END {print sum}'`
fi
sleep 5
echo {PDSH} -u 5 -f 100 -w ssh:pc-lab[${REMOTE_MACHINES_WITHOUT_AGENT_INDEX}] "${REMOTE_EXECUTOR_SCRIPT} ${OPER_TYPE_TGRID_SERVER} ${OPER_TYPE_AGENT} ${JAVA_TYPE} ${TGRID_ROOT_BIN_DIR} permutationExcludeRegex  ${AGENT_REGEX_VALUE} ${AGENTS_TYPE} " 
total_agents=`${PDSH} -u 5 -f 100 -w ssh:pc-lab[${REMOTE_MACHINES_WITHOUT_AGENT_INDEX}] "${REMOTE_EXECUTOR_SCRIPT} ${OPER_TYPE_TGRID_SERVER} ${OPER_TYPE_AGENT} ${JAVA_TYPE} ${TGRID_ROOT_BIN_DIR} permutationExcludeRegex  ${AGENT_REGEX_VALUE} ${AGENTS_TYPE} " | grep "${TOTAL_RUNNING_AGENT_MSG}" | awk -F: '{sum += $3}; END {print sum}'`
#total_agents=`${PDSH} -f 100 -w ssh:pc-lab[${REMOTE_MACHINES}] "${REMOTE_EXECUTOR_SCRIPT} ${OPER_TYPE_TGRID_SERVER} ${OPER_TYPE_AGENT} ${JAVA_TYPE} ${TGRID_ROOT_BIN_DIR} " | grep "${TOTAL_RUNNING_AGENT_MSG}" | awk -F: '{sum += $3}; END {print sum}'`

printf "\n"
if [ "${total_agents}" != "" ]
 then 
   printf "Total TGrid Agents: ${total_agents}\n"
fi
