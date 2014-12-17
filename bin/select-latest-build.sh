#!/bin/bash

#echo to stdout the build number of the last build in tarzan that of type 5_Sun8
#Exit with status 0 if found.
#Exit with status 1 if not.

for i in $( ls -1 /mnt/tarzan/builds/xap/xap10/10.1.0/ | sort -r ); do
  if ( echo $i | grep -q "^build_.*" )
  then
      unzip -q -c /mnt/tarzan/builds/xap/xap10/10.1.0/$i/jars/1.5/JSpacesTestSuite.jar META-INF/MANIFEST.MF | grep -q "tgrid-suite-target-jvm: 5_Sun8"
      if [ $? -eq 0 ] 
      then
          echo "$i" | sed -e 's/build_//'
          exit 0
      fi
  fi
done

return 1;


