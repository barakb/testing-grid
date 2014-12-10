#!/bin/bash
#
# This script provides the command and control utility for the
# GigaSpaces Technologies Inc. Service Grid

scriptDir="$(dirname $0)"
command_line=$*
start=



if [ "$1" = "start" ]; then
    start=1
    shift
    command_line=$*
fi

# Check to see if path conversion is needed
toNative() {
    # Check for Cygwin
    case $OS in
        Windows*)
           toWindows "$@";;
           *) echo $* ;;
    esac
}

# The call to setenv.sh can be commented out if necessary.
. `dirname $0`/setenv.sh

# set bootclasspath
bootclasspath="-Xbootclasspath/p:$(toNative $XML_JARS)"

SERVICE_GRID_LIB="$JSHOMEDIR/lib/ServiceGrid"
JINI_LIB="$JSHOMEDIR/lib/jini"

# Function to find a file
getPathForFile() {
    filename="$1"
    if [ -f "$SERVICE_GRID_LIB/$filename" ] ; then
	located="$SERVICE_GRID_LIB/$filename"
    else
	if [ -f "$JSHOMEDIR/lib/sg/$filename" ] ; then
	    located="$JSHOMEDIR/lib/sg/$filename"
        else
	    echo "Cannot locate $filename in the expected directory structure, exiting"
	    exit 1
        fi
    fi
}

# Locate the boot strapping jars
getPathForFile gs-boot.jar
gsboot=$located

getPathForFile gs-lib.jar
gslib=$located

getPathForFile gs-admin.jar
gsadmin=$located

cygwin=
case $OS in
    Windows*)
        cygwin=1
esac

# Cygwin utility to convert path if running under windows
toWindows() {
    cygpath -pw "$@"
}

# If the command is to start the Service Grid, invoke the SystemBoot facility.
# Otherwise invoke the CLI to interafce with the product
if [ "$start" = "1" ]; then
    NATIVE_DIR="$(toNative $SERVICE_GRID_LIB/native)"
    # Check for running on OS/X
    opSys=`uname -s`
    if [ $opSys = "Darwin" ] ; then
        export DYLD_LIBRARY_PATH=$NATIVE_DIR
    else
        if [ "$cygwin" = "1" ] ; then
            libpath="-Djava.library.path=$NATIVE_DIR"
        else
            export LD_LIBRARY_PATH=$NATIVE_DIR
        fi
    fi

    classpath="-cp $(toNative $EXT_JARS:$JDBC_JARS:$JSHOMEDIR:$JMX_JARS:$gsboot:$JINI_LIB/start.jar)"
    launchTarget=com.gigaspaces.start.SystemBoot
    "$JAVACMD" $bootclasspath $classpath ${JAVA_OPTIONS} ${RMI_OPTIONS} $libpath ${LOOKUP_GROUPS_PROP} ${LOOKUP_LOCATORS_PROP} -Dcom.gs.logging.debug=false ${GS_LOGGING_CONFIG_FILE_PROP} $NETWORK $DEBUG $launchTarget $command_line
else
    cliExt="$JSHOMEDIR/config/tools/gs_cli.config"
    launchTarget=com.gigaspaces.admin.cli.GS
    classpath="-cp $(toNative $JDBC_JARS:$JSHOMEDIR:$JMX_JARS:$gsadmin:$gslib:$JINI_LIB/jsk-lib.jar:$JINI_LIB/jsk-platform.jar:$JSHOMEDIR/lib/JSpaces.jar:$OPENSPACES_JARS:$SPRING_JARS:$COMMON_JARS)"
    "$JAVACMD" $bootclasspath $classpath ${RMI_OPTIONS} ${LOOKUP_GROUPS_PROP} ${LOOKUP_LOCATORS_PROP} -Dcom.gs.logging.debug=false -Dhandlers=java.util.logging.FileHandler ${GS_LOGGING_CONFIG_FILE_PROP} $launchTarget $cliExt $command_line
    
fi
