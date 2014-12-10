#!/bin/bash
. `dirname $0`/setenv.sh

"${JAVACMD}" -cp $GS_JARS -Djava.security.policy=${POLICY} com.sun.jini.example.browser.Browser
