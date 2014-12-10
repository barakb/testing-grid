#!/bin/bash

#cleanup oracle DB, will be located under QA/bin
java -cp ${BUILD_CACHE_DIR}/QA/lib/tf.jar:${BUILD_CACHE_DIR}/QA/lib/jdbc/ojdbc14.jar com.gigaspaces.framework.tools.CleanDB 192.168.9.71 1521 XE tgrid tgrid

