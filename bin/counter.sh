#!/bin/bash


COUNTER_FILE="$1/counter.tmp"

if [ ! -f $COUNTER_FILE ]; then
    count=0
else
    count=`cat $COUNTER_FILE`
fi
next=$(expr $count + 1)
next=$(expr $next % 100)

echo $next >$COUNTER_FILE
printf "%02d" $next




