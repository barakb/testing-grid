#!/bin/bash
find /export/builds/6* -mtime +15 -name build_[0-9]* |  grep "build_[0-9]\{4\}-" | awk '{print "rm -rf",$1}' > /tmp/list_of_builds_to_delete
