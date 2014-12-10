#!/bin/sh

BUILD_DIR=`pwd`/../local-builds/$1;
echo "investigating ${BUILD_DIR} directory"

RETVAL=checksucess; 
for file in `find ${BUILD_DIR}`; do 
  if [ `grep  -c no.invocation.in.progress.at.the.server $file` -gt 0 ]; then 
    echo `grep  -Hn no.invocation.in.progress.at.the.server $file`; 
    RETVAL=checkfailed;  
  fi ;  
done; 

echo $RETVAL;
