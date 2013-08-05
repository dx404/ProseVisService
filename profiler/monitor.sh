#!/bin/bash
echo "==== Profiling ===="
top -u $USER -d 1 -b >> log/prof_pv${taskID}_${time_stamp}.txt 
