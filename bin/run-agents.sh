#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Usage: $0 n (where n is the nuber of anget to run on local machine"
    exit 1
fi

echo "starting $1 agents." 

for ((i=1;i<=$1;i++));
do
   nohup ./agent.sh &> /dev/null &
   echo "starting egent $i"
done
