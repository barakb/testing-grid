#!/bin/bash

. set-build-env.sh

TARGET_LIST_DIRECTORY=$1
MAX_SHOW_ITEMS=$2

# set a default regression build path to list 
if [ "${TARGET_LIST_DIRECTORY}" = "" ]
  then
     TARGET_LIST_DIRECTORY=${REGRESSION_BUILDS_PATH}
fi

# set a default number of show items
if [ "${MAX_SHOW_ITEMS}" = "" ] 
  then  
    MAX_SHOW_ITEMS=10 
fi

declare -a array_name 
#TODO add time for build list : awk '{print $9 "   " $6 " " $7 " " $8}'
#fill array with directories of available builds 
array_name=( `ls -lt ${TARGET_LIST_DIRECTORY} | grep build_ | awk '{print $9}'`)
element_count=${#array_name[*]}
if [ ${element_count} -lt $MAX_SHOW_ITEMS ]
 then
   MAX_SHOW_ITEMS=${element_count}
fi

# The -n option to echo suppresses newline.
echo "Enter the build from 1-$MAX_SHOW_ITEMS to run the regression: "

#init vars
index=0
list_pointer=1

#while [ "$index" -lt "$element_count" ]
while [ $index -lt $MAX_SHOW_ITEMS ]
do    # List all the elements in the array.
  let "list_pointer = $index + 1"
  printf "%s. %s %s \n" $list_pointer ${array_name[index]} 
  let "index = $index + 1"
done

# get the input 
echo -n "Input: "
read buildId

#keey the full dir path to selected build
SELECTED_BUILD_DIR=${TARGET_LIST_DIRECTORY}/${array_name[buildId-1]}
SELECTED_BUILD_NAME=${array_name[buildId-1]}

echo Selected build is : ${SELECTED_BUILD_DIR}

