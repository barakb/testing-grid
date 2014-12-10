#!/bin/bash
# This script starts GigaSpaces Management Center

scriptDir="$(dirname $0)"

. `dirname $0`/setenv.sh

SERVICE_GRID_LIB="$JSHOMEDIR/lib/ServiceGrid"
JINI_LIB="$JSHOMEDIR/lib/jini"

# Function to determine if path conversion is required
toNative() {
    # Check for Cygwin
    case $OS in
        Windows*)
           toWindows "$@";;
        *) echo $* ;;
    esac
}

# Perform conversion if Windows
toWindows() {
    cygpath -pw "$@"
}

classpath="$(toNative $UI_JARS:$EXT_JARS:$JDBC_JARS:$HIBERNATE_JARS:$JMX_JARS:$SERVICE_GRID_LIB/gs-adminui.jar:$JSHOMEDIR/lib/JSpaces.jar:$SERVICE_GRID_LIB/gs-lib.jar:$JINI_LIB/jsk-lib.jar:$JINI_LIB/jsk-platform.jar:$OPENSPACES_JARS:$SPRING_JARS:$COMMON_JARS)"
bootclasspath="-Xbootclasspath/p:$(toNative $XML_JARS)"
launchTarget=com.gigaspaces.admin.ui.MainUI
config="$(toNative $JSHOMEDIR/config/tools/adminui.config)"

command_line=$*

NATIVE_DIR="$(toNative $SERVICE_GRID_LIB/native)"

opSys=`uname -s`
if [ $opSys = "Darwin" ] ; then
    export DYLD_LIBRARY_PATH=$NATIVE_DIR
    DARWIN_PROPS="-Dcom.gs.ui.laf.classname=apple.laf.AquaLookAndFeel -Dcom.apple.macos.useScreenMenuBar=true -Xdock:name=GigaSpacesBrowser -Dcom.apple.mrj.application.growbox.intrudes=false -Dcom.apple.mrj.application.live-resize=true"
else
	export LD_LIBRARY_PATH="$NATIVE_DIR"
fi

SYS_PROPS="-Dcom.gs.env.report=false -Dcom.gs.jini.useDefinedGroupOnly=false -Dcom.gs.browser.containername=mySpace_container -Dcom.gs.logging.debug=true -Dcom.gs.embeddedQP.enabled=true -Djava.protocol.handler.pkgs=net.jini.url ${DARWIN_PROPS}"
export SYS_PROPS

command="$JAVACMD $bootclasspath -cp "$classpath" ${JAVA_OPTIONS} ${RMI_OPTIONS} ${SYS_PROPS} ${GS_LOGGING_CONFIG_FILE_PROP} ${LOOKUP_GROUPS_PROP} ${LOOKUP_LOCATORS_PROP} $launchTarget $config $command_line"

echo
echo Starting GigaSpaces Management Center:
echo 
echo ${command}
echo
echo
$command
