#!/bin/bash
#-------------------------------------------------------------------------------
# This short script is for closing the Open-Mary Service
# It bases on the PID of the Open-Mary Process
#-------------------------------------------------------------------------------
sleep 5
kill $(ps | grep 'marytts' | awk '{print $1}')
kill $(ps | grep 'java' | awk '{print $1}')