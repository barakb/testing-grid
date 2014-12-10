#!/bin/bash

##
# This script provides setup enviroment of distributed TGrid Agents dagent.sh & remote-cmd-executor.sh.
# and contains all shared variables and functions.
# Important to keep all vars here to coordinate dagent.sh and remote-cmd-executor.sh with the same vars values. 
#
# @see dagent.sh
# @see remote-cmd-executor.sh 
# @author Igor Goldenberg
##

#setup vars
PDSH="/export/utils/bin/pdsh"
CONFIG_JAVA_SCRIPT=". /export/utils/bin/configJava.sh"
#TGRID_ROOT_BIN_DIR="/export/builds/tgrid/TestingGrid-latest/bin"
TGRID_ROOT_BIN_DIR="/export/tgrid/TestingGrid-latest/bin"
REMOTE_EXECUTOR_SCRIPT=". ${TGRID_ROOT_BIN_DIR}/remote-cmd-executor.sh"

# all agents operation types
TOTAL_AGENTS_OPER_TYPE=1
START_AGENTS_OPER_TYPE=2
KILL_AGENTS_OPER_TYPE=3

#default operations
DEFAULT_OPER_TYPE_TGRID_SERVER=1
DEFAULT_OPER_TYPE_AGENT=1
DEFAULT_REMOTE_MACHINES=7-13,15-30

# awk of dagent.sh does parse this message from output of remote-cmd-executor.sh to get total agents
TOTAL_RUNNING_AGENT_MSG="Total running agents:"

# keep maping all agent operations
map_agent_opers=("Get total Agents" "Start agents" "Kill all agents")

# show all available agent's operation type from map_agent_opers
show_agent_opers()
{
   index=0
   list_pointer=1
   while [ "${index}" -lt "${#map_agent_opers[*]}" ]
   do    # List all the elements in the array.
      let "list_pointer = $index + 1"
      echo $list_pointer. ${map_agent_opers[index]}
      let "index = $index + 1"
   done
}

# calculate total running agents
calc_total_agents()
{
  TOTAL_RUNNING_AGENTS=`ps -aef | grep java | grep -v grep | grep "com.gigaspaces.tgrid.agent.Agent" | wc -l`
}
