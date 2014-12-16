#!/bin/bash

if [ $# -eq 0 ]; then
  echo -e "\nUsage $0 build_[build-number] : install this build and mark it to run in the next loop\n"
  echo -e "\nUsage $0 mileston [build-number-prefix] : install the last build of this milestone and mark it to run in the next loop\n"
  exit 1
elif [ $# -eq 1 ]; then
  BUILD=$1
elif [ $# -eq 2 ]; then
  echo "ls -1 /mnt/tarzan/builds/xap/xap10/10.1.0/ | grep $2 | tail -n1"
  BUILD=`ls -1 /mnt/tarzan/builds/xap/xap10/10.1.0/ | grep $2 | tail -n1`
  echo "BUILD is $BUILD"
fi

echo "${BUILD}" > build.txt

BUILDDIR=../local-builds/${BUILD}
if [ -d "${BUILDDIR}" ];
then
  echo "folder ${BUILDDIR} exists"
  exit 1;
fi

echo "Installing ${BUILD} into ${BUILDDIR}"
echo "Waiting 30 seconds for builder deployment finish"

mkdir -p  ${BUILDDIR}
PREFIX="build_";
BUILD_NO=${BUILD#$PREFIX}
cp /mnt/tarzan/builds/xap/xap10/10.1.0/${BUILD}/xap-premium/1.5/gigaspaces-xap-premium-*-b${BUILD_NO}.zip ${BUILDDIR}/
cp /mnt/tarzan/builds/xap/xap10/10.1.0/${BUILD}/testsuite-1.5.zip  ${BUILDDIR}
for f in ${BUILDDIR}/*.zip
do 
    unzip -uo $f -d ${BUILDDIR}
done

rm ${BUILDDIR}/*.zip

#barak todo remove when builds with good tf.jar starts comming. 16/12
cp -f  ../tf.jar ${BUILDDIR}/QA/lib/

