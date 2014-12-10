#!/bin/bash

BUILD_NUMBER=$1
SPRINT_VERSION_PAGE=$2
WIKI_SERVER=http://wiki:8080
#WIKI_SERVER=http://192.168.9.35:8080
SPACE_NAME=QA
USER_NAME=tgrid
PASSWORD=tgrid
RESULT_PARENT_PAGE="Nightly Regression ${BUILD_NUMBER}"
WIKI_FILE_PATH="../local-builds/build_${BUILD_NUMBER}/QA/report"
#WIKI_FILE_PATH="/mnt/file-srv/tgrid/TestingGrid-latest/local-builds/build_${BUILD_NUMBER}/QA/report"

if [ -z "${BUILD_NUMBER}" ]
  then
    echo "Usage: wiki-reporter.sh [build-number] [sprint-version title page]"
    exit 1
fi

# build version 1800 and sprint page name for i.e "Regression Report 6.0.1 Sprint 9"
if [ -z "${SPRINT_VERSION_PAGE}" ]
  then
    echo "Usage: wiki-reporter.sh [build-number] [sprint-version title page]"
    exit 1
fi

upload()
{
  java -Xmx512m -jar /export/tgrid/TestingGrid-latest/lib/ext/wiki/confluence-soap-0.5.jar --server "${WIKI_SERVER}" --user "${USER_NAME}" --password "${PASSWORD}" --space "${SPACE_NAME}" --action storePage --title "${TITLE_PAGE}" --parent "${PARENT_PAGE}" --file "${WIKI_FILE_PATH}/${WIKI_FILE}" 
}

# upload summary page
TITLE_PAGE="Nightly Regression ${BUILD_NUMBER}"
PARENT_PAGE=${SPRINT_VERSION_PAGE}
WIKI_FILE="summary.wiki"
upload

PARENT_PAGE=${RESULT_PARENT_PAGE}

# upload passed page
TITLE_PAGE="Passed tests ${BUILD_NUMBER}"
WIKI_FILE="passed-tests.wiki"
upload

# upload failure page
TITLE_PAGE="Failed tests ${BUILD_NUMBER}"
WIKI_FILE="failed-tests.wiki"
upload

# upload suite-breakdown page
TITLE_PAGE="Suite break down ${BUILD_NUMBER}"
WIKI_FILE="suite-breakdown.wiki"
upload
