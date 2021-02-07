#!/bin/bash

FILE=$1
COUNT=1
while [ ! -e "$FILE" ]; do
    echo $FILE Does not yet exists N=$COUNT
    sleep 5
    COUNT=$((COUNT+1))
done

echo $FILE exists
md5sum $FILE
echo $FILE ready

