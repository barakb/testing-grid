#!/bin/bash

. set-tgrid-env.sh

BUILD_NUMBER=$1
BUILD_JDK_VER=$2

# if not <null> set supplied jdk version otherwise use default from set-build-env.sh
if [ -z "${BUILD_JDK_VER}" ]
 then
   BUILD_JDK_VER=1.5
fi

#according to this variables will be created a full path to the GS build
BUILD_VERSION=$5
BUILD_MILESTONE=$6
BUILD_TYPE=$7
BUILD_INSTALL_DIR=gigaspaces-${BUILD_TYPE}-${BUILD_VERSION}-${BUILD_MILESTONE}
export REMOTE_MACHINES_USING_AGENT_REGEX=$9
export AGENT_REGEX_VALUE=${10}

if [ "x$8" = "xcpp64" ]
 then
  CPP_PACKAGE_NAME=gigaspaces-cpp-${BUILD_VERSION}-${BUILD_MILESTONE}-linux-amd64-gcc-3.4.5
 elif [ "x$8" = "xcpp32" ]
 then
  CPP_PACKAGE_NAME=gigaspaces-cpp-${BUILD_VERSION}-${BUILD_MILESTONE}-linux32-gcc-3.4.6
fi
CPP_TAR_FILE=${CPP_PACKAGE_NAME}.tar
CPP_TARGZ_FILE=${CPP_PACKAGE_NAME}.tar.gz

# location to director with all regression builds
REGRESSION_BUILDS_PATH=/opt/builds/${BUILD_VERSION}

#this directory contains all GS builds all ever ran by this user, every build downloaded to the specified directory and use locally! 
BUILDS_CACHE_REPOSITORY=${TGRID_ROOT_DIR}/local-builds

#every build directory contains QA directory with all tests results of this build
QA_TESTSUITE_FILENAME=JSpacesTestSuite.jar

# postfix directory name to the test-suite jar, on setup test-suite will be downloaded from $REGRESSION_BUILDS_PATH/build_XXX/$QA_TESTSUITE_JAR_SERVER_REPOSITORY_PATH
QA_TESTSUITE_JAR_SERVER_REPOSITORY_PATH=testsuite-${BUILD_JDK_VER}.zip

MAIL_ENABLED=false; export MAIL_ENABLED
