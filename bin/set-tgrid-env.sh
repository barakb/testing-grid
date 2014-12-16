#!/bin/bash -x

# - Set or override the JAVA_HOME variable
# - By default, the system value is used.
# JAVA_HOME="/utils/jdk1.5.0_01"
# - Reset JAVA_HOME unless JAVA_HOME is pre-defined.
if [ -z "${JAVA_HOME}" ]; then
  echo "The JAVA_HOME environment variable is not set. Using the java that is set in system path."
 JAVACMD=java
 else
  JAVACMD="${JAVA_HOME}/bin/java"
fi

# hostname
HOST=`hostname`; export HOST

#home directory of Testing Grid
#TGRID_ROOT_DIR=`dirname $0`/..
TGRID_ROOT_DIR=`pwd -P`/..

# this variable appends additional jars to the TGrid classpath
APPEND_TO_CLASSPATH_ARG="$1"

# TestingGrid runtime
RUNTIME_HOMEDIR=${TGRID_ROOT_DIR}/runtime/GigaSpaces

# Initializing TGridRuntime 
JSHOMEDIR=${RUNTIME_HOMEDIR}; export JSHOMEDIR

#added NOT TESTED
echo setting custom lookupgroups in ssd tests
echo target machines: "$TARGET_MACHINES"
if [ "$TARGET_MACHINES" = "132,133" ] ; then
LOOKUPGROUPS="gigaspaces-SSD"; export LOOKUPGROUPS
fi
echo new lookup is : "$LOOKUPGROUPS"
#end of added

# Initiliaze TGrid runtime
. ${RUNTIME_HOMEDIR}/bin/setenv.sh

#TGrid logging prop-file
TGRID_LOGGING_FILE_PROP="-Djava.util.logging.config.file=${TGRID_ROOT_DIR}/config/tgrid_logging.properties"

# Console reporter property
#-Dtgrid-suite-reporters=com.gigaspaces.tgrid.report.ConsoleReporter

# TGrid JVM system properties
#TGRID_SANITY_FILE="-Dtgrid-suite-factory-args=externalPermutationFile=/home/xap/testing-grid/bin/permutations.txt"
TGRID_JVM_PROPERTIES="-Djava.security.policy=${RUNTIME_HOMEDIR}/policy/policy.all ${TGRID_LOGGING_FILE_PROP} -Djava.rmi.server.useCodebaseOnly=false -Dcom.gigaspaces.tgrid.base-build-dir=/var/tmp/tgrid ${TGRID_SANITY_FILE}"

# TGrid Manifest Overrides
MANIFEST_OVERRIDES=$8

#append to classpath all directories with jars located under lib/ext directory
array_name=(`find ${TGRID_ROOT_DIR}/lib/ext -name "*jar"`)
element_count=${#array_name[*]}

index=0
while [ $index -lt $element_count ]
do
  EXT_TGRID_JARS=${EXT_TGRID_JARS}:${array_name[index]}
  let "index = $index + 1"
done

# TGrid classpath
#TGRID_RUNTIME_JARS="${RUNTIME_HOMEDIR}/lib/required/gs-runtime.jar"
TGRID_RUNTIME_JARS="${RUNTIME_HOMEDIR}/lib/JSpaces.jar:${RUNTIME_HOMEDIR}/lib/spring/cglib-nodep-2.1_3.jar"
TGRID_JARS="${TGRID_ROOT_DIR}/lib/tgrid.jar"
TGRID_CLASSPATH=${APPEND_TO_CLASSPATH_ARG}:${TGRID_RUNTIME_JARS}:${TGRID_JARS}:${EXT_TGRID_JARS}

#TGrid execution command
TGRID_EXEC_CMD="${JAVACMD} ${TGRID_JVM_PROPERTIES} -cp ${TGRID_CLASSPATH}"

printf "\n === TestingGrid exec-command ==== \n" 
echo ${TGRID_EXEC_CMD}
printf " ===\n\n"
