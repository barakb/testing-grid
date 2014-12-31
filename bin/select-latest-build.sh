#!/bin/bash

#echo to stdout the build number of the last build in tarzan that of type 5_Sun8
#Exit with status 0 if found.
#Exit with status 1 if not.

for i in $( ls -1 /mnt/tarzan/builds/xap/xap10/10.1.0/ | sed -r 's/build_([0-9]+)-([0-9]+)/\1\2 \0/' | sort -r -s -n -k 1,1| sed -r 's/^([0-9])+ (.*)$/\2/' ); do
  if ( echo $i | grep -q "^build_.*" )
  then
      unzip -q -c /mnt/tarzan/builds/xap/xap10/10.1.0/$i/jars/1.5/JSpacesTestSuite.jar META-INF/MANIFEST.MF | grep -Eq "tgrid-suite-target-jvm:\ *(5_Sun8|4_Sun7|1_Sun16)"
      if [ $? -eq 0 ] 
      then
          echo "$i" | sed -e 's/build_//'
          exit 0
      else
         echo "not found 5_Sun8 in jar /mnt/tarzan/builds/xap/xap10/10.1.0/$i/jars/1.5/JSpacesTestSuite.jar"
         unzip -q -c /mnt/tarzan/builds/xap/xap10/10.1.0/$i/jars/1.5/JSpacesTestSuite.jar META-INF/MANIFEST.MF | grep  "tgrid-suite-target-jvm:"
      fi
  fi
done

return 1;
