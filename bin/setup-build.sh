#!/bin/bash

. set-build-env.sh

printf "\n"
echo "###############################################" 
echo "#  Welcome to the GigaSpaces Testing Grid!    #"
echo "#  We are making your life scalable...		#"
echo "###############################################" 
printf "\n\n"

# run regression with supplied build-name or empty to get full list of available builds
SELECTED_BUILD_NAME=$1

# show the list of available regression builds on build=server, if $SELECTED_BUILD_NAME is not defined
if [ "${SELECTED_BUILD_NAME}" = "" ]
 then
  . list-builds.sh ${REGRESSION_BUILDS_PATH}
fi

# set local build directory with entered build number
BUILD_CACHE_DIR=${BUILDS_CACHE_REPOSITORY}/${BUILD_NUMBER}
IS_BUILD_EXIST=${BUILDS_CACHE_REPOSITORY}/${BUILD_NUMBER}
 if [ ! -d ${IS_BUILD_EXIST} ];
   then

# start to download the build from the main build repository
BUILD_NUMBER=`echo ${SELECTED_BUILD_NAME} | awk '{print substr($1,7)}'`
BUILD_FILE=${BUILD_INSTALL_DIR}_${BUILD_JDK_VER}_b${BUILD_NUMBER}.zip

if [ "${BUILD_JDK_VER}" = "1.5" ]
 then
        BUILD_FILE=${BUILD_INSTALL_DIR}-b${BUILD_NUMBER}.zip
 else
        BUILD_FILE=${BUILD_INSTALL_DIR}-${BUILD_JDK_VER}-b${BUILD_NUMBER}.zip
fi


# full path to the build.zip file
BUILD_PATH=${REGRESSION_BUILDS_PATH}/${SELECTED_BUILD_NAME}/${BUILD_TYPE}/${BUILD_JDK_VER}/${BUILD_FILE}

#check that build-file path is available and readable
if [ ! -r ${BUILD_PATH} ]
 then
    echo "ERROR: Build file doesn't not exist: ${BUILD_PATH}"
    exit 1
fi

############ Download the supplied build number to the cache_directory ################

# set local build directory with entered build number
BUILD_CACHE_DIR=${BUILDS_CACHE_REPOSITORY}/${SELECTED_BUILD_NAME}

echo Removing the old build directory if exists...
rm -rf ${BUILD_CACHE_DIR}

echo Removing old persistent directories if exist

rm -rf ~/.gigaspaces/persistent

# creating local build directory: 
echo Creating local build directory of selected build: ${BUILD_CACHE_DIR}
mkdir $BUILD_CACHE_DIR

printf "\n *** Starting to download build:"
echo ${BUILD_PATH}
printf "\n *** Please wait, setup in progress..."
sleep 2

# copy the download file to cache dir repository
cp ${BUILD_PATH} ${BUILD_CACHE_DIR}

#introduce new variable: full path to build zip file
FULL_PATH_TO_BUILD_ZIP_FILE=${BUILD_CACHE_DIR}/${BUILD_FILE}

if [ ! -r  ${FULL_PATH_TO_BUILD_ZIP_FILE} ]
 then
  echo "ERROR: Failed to download $BUILD_FILE file. File does not exist or is not readable. *The build number might be wrong.*"  
  exit 1
fi
############ End of download ###########

#unzip build
printf "\n *** Starting to unzip Build file: ${BUILD_FILE} ..."
sleep 2
unzip ${FULL_PATH_TO_BUILD_ZIP_FILE} -d ${BUILD_CACHE_DIR}

#check if unzip successed
if [ ! -d ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR} ]
 then
   echo "ERROR: Failed to unzip ${BUILD_FILE}. *Zip file might be currupted or not readable*"  
  exit 1
 fi
  
#copy CPP package
if [ "xcpp" = "x`echo $8 | awk '{print substr($1,1,3)}'`" ]
 then
  printf  "\n *** CPP package exists. Starting to  copy ${REGRESSION_BUILDS_PATH}/${SELECTED_BUILD_NAME}/${CPP_TARGZ_FILE}"
  cp ${REGRESSION_BUILDS_PATH}/${SELECTED_BUILD_NAME}/${CPP_TARGZ_FILE} ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}
  printf  "\n *** Starting to ungzip ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}/${CPP_TARGZ_FILE}"
  gzip -d ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}/${CPP_TARGZ_FILE}
  printf  "\n *** Starting to untar ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}/${CPP_TAR_FILE}"
  tar  -C ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR} -xf  ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}/${CPP_TAR_FILE} 
  chmod -R 777 ${BUILD_CACHE_DIR}/${BUILD_INSTALL_DIR}/cpp	
 else
  printf "\n *** CPP package doesn't exist. Skipping unzip"
fi

#delete the original zip file
printf "\n *** Deleting original Build file: ${BUILD_FILE} file..."
sleep 2

rm -rf ${FULL_PATH_TO_BUILD_ZIP_FILE}

#full path to the build-suite jar 
TEST_SUITE_URL=${REGRESSION_BUILDS_PATH}/${SELECTED_BUILD_NAME}/${QA_TESTSUITE_JAR_SERVER_REPOSITORY_PATH}/${QA_TESTSUITE_FILENAME}
printf "\n ***  Unziping : ${QA_TESTSUITE_JAR_SERVER_REPOSITORY_PATH} ...\n"
sleep 2
unzip -d ${BUILD_CACHE_DIR} ${REGRESSION_BUILDS_PATH}/${SELECTED_BUILD_NAME}/${QA_TESTSUITE_JAR_SERVER_REPOSITORY_PATH}
#cp ${TEST_SUITE_URL} ${BUILD_CACHE_DIR}/QA/suite-jars

else
     # build exists in local-builds - don't download it, just use it.
     echo "using build already found in ${BUILDS_CACHE_REPOSITORY}"
fi

#End of process
printf "\n *** Setup build ${SELECTED_BUILD_NAME} finished successfully.\nFull build path: ${BUILD_CACHE_DIR} \n"
sleep 2
