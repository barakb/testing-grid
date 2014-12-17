#!/bin/bash


#BUILD=build_12588-2798
#BUILD_NO=12588-2798
BUILD_NO=`./select-latest-build.sh`
BUILD=build_${BUILD_NO}
echo "${BUILD_NO}" > build.txt


echo "-------------"
cat build.txt
echo "-------------"


BUILDDIR=../local-builds/${BUILD_NO}
if [ -d "${BUILDDIR}" ];
then
  echo "folder ${BUILDDIR} exists"
  exit 1;
fi

echo "Installing ${BUILD} into ${BUILDDIR}"
echo "Waiting 30 seconds for builder deployment finish"

mkdir -p  ${BUILDDIR}
PREFIX="build_";

cp /mnt/tarzan/builds/xap/xap10/10.1.0/${BUILD}/xap-premium/1.5/gigaspaces-xap-premium-*-b${BUILD_NO}.zip ${BUILDDIR}/
cp /mnt/tarzan/builds/xap/xap10/10.1.0/${BUILD}/testsuite-1.5.zip  ${BUILDDIR}
for f in ${BUILDDIR}/*.zip
do 
    unzip -uo $f -d ${BUILDDIR}
done

rm ${BUILDDIR}/*.zip

#barak todo remove when builds with good tf.jar starts comming. 16/12
#cp -f  ../tf.jar ${BUILDDIR}/QA/lib/

