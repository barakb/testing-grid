#!/bin/sh
. `dirname $0`/setenv.sh

"${JAVACMD}" -cp $JSHOMEDIR/lib/jini/jsk-lib.jar:$JSHOMEDIR/lib/jini/jsk-platform.jar:$JSHOMEDIR/lib/jini/reggie.jar:$JSHOMEDIR/lib/jini/browser.jar:$JSHOMEDIR/lib/JSpaces.jar:$JSHOMEDIR/lib/ServiceGrid/gs-boot.jar -Djava.security.policy=${POLICY} com.sun.jini.example.browser.Browser
