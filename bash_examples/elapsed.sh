#!/usr/bin/env bash

STARTTIME=$(date +%s)
#command block that takes time to complete...
#........
sleep 2
ENDTIME=$(date +%s)
echo "It takes $(($ENDTIME - $STARTTIME)) seconds to complete this task..."