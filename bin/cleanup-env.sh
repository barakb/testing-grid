#!/bin/bash

# When regression finished this script will be called to cleanup build enviroment.
# For example: remove persistent db files, unnecessary logs and etc...

TARGET_MACHINES=$4

# get BUILD_INSTALL_DIR 
. set-build-env.sh 

#cleanup output-build directories, later on this script will be located under QA/bin
echo "Regression finished. Starting to cleanup..."
echo "Removing installation directory: ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}"
rm -rf ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}

echo "Removing all persistent directories from every test-output directory..."
pdsh -w ssh:pc-lab[${TARGET_MACHINES}] "rm -rf /tmp/tgrid*"
find ${BUILD_CACHE_DIR}/QA/status | grep /persistent | grep -v dbs | xargs rm -rf

echo "Starting to cleanup Oracle at pc-lab64 ..."
. clean-oracle.sh

echo "Cleanup finished..."

