#!/bin/bash
# This script starts GigaSpaces Management Center

scriptDir="$(dirname $0)"

. `dirname $0`/setenv.sh

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

classpath="$(toNative $PRE_CLASSPATH:$JSHOMEDIR:$UI_JARS:$JDBC_JARS:$HIBERNATE_JARS:$JMX_JARS:$GS_JARS:$SPRING_JARS:$POST_CLASSPATH)"
bootclasspath="-Xbootclasspath/p:$(toNative $XML_JARS)"
launchTarget=com.gigaspaces.admin.ui.MainUI
config="config/tools/adminui.config"

command_line=$*

NATIVE_DIR="$(toNative $JSHOMEDIR/lib/platform/native)"

opSys=`uname -s`
if [ $opSys = "Darwin" ] ; then
    export DYLD_LIBRARY_PATH=$NATIVE_DIR
    DARWIN_PROPS="-Dcom.gs.ui.laf.classname=apple.laf.AquaLookAndFeel -Dcom.apple.macos.useScreenMenuBar=true -Xdock:name=GigaSpacesBrowser -Dcom.apple.mrj.application.growbox.intrudes=false -Dcom.apple.mrj.application.live-resize=true"
else
	export LD_LIBRARY_PATH="$NATIVE_DIR"
fi

SYS_PROPS="-Dcom.gs.env.report=false -Dcom.gs.jini.useDefinedGroupOnly=false -Dcom.gs.browser.containername=mySpace_container -Dcom.gs.logging.debug=true -Dcom.gs.embeddedQP.enabled=true -Djava.protocol.handler.pkgs=net.jini.url ${DARWIN_PROPS}"
export SYS_PROPS

command="$JAVACMD ${JAVA_OPTIONS} $bootclasspath -cp "$classpath" ${RMI_OPTIONS} ${SYS_PROPS} ${GS_LOGGING_CONFIG_FILE_PROP} ${LOOKUP_GROUPS_PROP} ${LOOKUP_LOCATORS_PROP} $launchTarget $config $command_line"

echo
echo Starting GigaSpaces Management Center:
echo 
echo ${command}
echo
echo
$command
