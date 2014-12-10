#!/bin/bash
# This script provides the command and control utility for the 
# GigaSpaces Technologies gsInstance.
# The gsInstance script starts a space using the SpaceFinder utility.

# Usage: If no args are passed, it will use the default Space URL.
# Arguments can be passed through a command line:

# arg 1  - the space URL (enclosed by ""), will be set into the SPACE_URL variable.
# If "" is passed the system will use the default space URL.

# arg 2 - a user defined path which will be appended to the beginning of the used classpath.
# The prefixed classpath needs to be enclosed by "" and the value will be set into the APPEND_TO_CLASSPATH_ARG variable

# arg 3  - Any additional command line arguments such as system properties. 
# The argument needs to be enclosed by "" and the value will be set into the APPEND_ADDITIONAL_ARG variable.

# E.g. gsInstance "/./newSpace?schema=persistent" "../../classes" "-DmyOwnSysProp=value -DmyOwnSysProp2=value"
# or gsInstance "" "" "-DmyOwnSysProp=value -DmyOwnSysProp2=value"
# In this case it will use the default space URL and classpath and just append new sys props.

# The call to setenv.sh can be commented out if necessary.
. `dirname $0`/setenv.sh

echo Starting a Space Instance
if [ "${JSHOMEDIR}" = "" ] ; then 
  JSHOMEDIR=`dirname $0`/..
fi
export JSHOMEDIR

bootclasspath="-Xbootclasspath/p:$XML_JARS"

# Check for Cygwin
cygwin=
case $OS in 
    Windows*) 
        cygwin=1
esac
# For Cygwin, ensure paths are in UNIX format before anything is touched
if [ "$cygwin" = "1" ]; then
    CPS=";"
else
    CPS=":"
fi
export CPS


if [ "${LOOKUPGROUPS}" = "" ] ; then
  LOOKUPGROUPS="gigaspaces-7.0.0-XAPPremium-ga"; export LOOKUPGROUPS
fi
LOOKUP_GROUPS_PROP=-Dcom.gs.jini_lus.groups=${LOOKUPGROUPS}; export LOOKUP_GROUPS_PROP

if [ "${LOOKUPLOCATORS}" = "" ] ; then
LOOKUPLOCATORS=; export LOOKUPLOCATORS
fi
LOOKUP_LOCATORS_PROP="-Dcom.gs.jini_lus.locators=${LOOKUPLOCATORS}"; export LOOKUP_LOCATORS_PROP

SPACE_URL="$1"
if [ "$1" = "" ] ; then 
  SPACE_URL="/./mySpace?schema=default&properties=gs&groups=${LOOKUPGROUPS}"
  echo Setting default space url to ${SPACE_URL}
else
  echo Setting space url to ${SPACE_URL}
fi

#  The user may append any user defined directories to the classpath.
APPEND_TO_CLASSPATH_ARG=$2

#  The user may append any additional properties (such as system properties like -Dxxx etc.) to the command line.
APPEND_ADDITIONAL_ARG=$3

COMMAND_LINE="${JAVACMD} ${JAVA_OPTIONS} $bootclasspath ${RMI_OPTIONS} ${LOOKUP_LOCATORS_PROP} ${LOOKUP_GROUPS_PROP} -Dcom.gs.home=${JSHOMEDIR} -Dcom.gs.start-embedded-lus=true -Dcom.gs.start-embedded-mahalo=false -Dcom.gs.logging.debug=false ${GS_LOGGING_CONFIG_FILE_PROP} ${APPEND_ADDITIONAL_ARG} -classpath "${PRE_CLASSPATH}${CPS}${APPEND_TO_CLASSPATH_ARG}${CPS}${EXT_JARS}$CPS${SIGAR_JARS}$CPS${JDBC_JARS}${CPS}${GS_JARS}${CPS}${POST_CLASSPATH}" com.j_spaces.core.client.SpaceFinder "${SPACE_URL}""

echo
echo
echo Starting gsInstance with line:
echo ${COMMAND_LINE}

${COMMAND_LINE}
echo
echo
