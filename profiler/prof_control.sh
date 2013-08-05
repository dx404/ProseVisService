#!/bin/bash
#==============================================================================
# 		 FILE: control.sh
#       USAGE: control.sh <unique_task_identifier>
# DESCRIPTION: The central script responsible for generating the task that is 
#              to submit to the Stampede job queue. It distinguishes two types 
#              of tasks, 
#                   (1) Analyze a single document
#                   (2) Compare Multple documents
#              Which corresponds to two branches of operatitons below
#
#      AUTHOR: Duo Zhao             (UNC Chapel Hill)
#          PI: Tanya Clement        (UT Austin)
#     CREATED: 08.02.2013
#
#==============================================================================

#------------------------------------------------------------------------------
#   Set up global variables
#   Create taskID from command-line input
#   The ProseVisService directory servers as the new root directory
#   The input files and output files are put under ./data directory 
#------------------------------------------------------------------------------
export taskID=$1
export username=$(id -un)
export hostname=$(hostname)
export pv_root=$HOME/ProseVisService
export src_dir=$pv_root/data/src
export dest_dir=$pv_root/data/results
export user_email="prosevis@$hostname"

#------------------------------------------------------------------------------
#   Set up the enviroment paths
#------------------------------------------------------------------------------
export PATH=\
$WORK/bin/marytts-5.0/bin:\
$pv_root/module/:\
$pv_root/tookit/:\
$pv_root/publisher/:\
$PATH

#------------------------------------------------------------------------------
# Start the downloading service
#------------------------------------------------------------------------------
download_pid=$(ps -u $username | grep "download.js" | awk '{print $1}')
if [ -n "$download_pid" ]; then 
	export port=$(netstat -pl | grep $download_pid | awk '{print $4}' | cut -d ':' -f 2)
else
	export port=$(portGet.py)
fi

nohup download.js $port \
> $pv_root/log/pv${taskID}_download.out \
2> $pv_root/log/pv${taskID}_download.err &

#------------------------------------------------------------------------------
# Change the current working directory to ProseVisService 
# Select the corresponding operation by reading the attached JSON file
#------------------------------------------------------------------------------
cd $pv_root
unzip -o -d data/src/ data/src/pv${taskID}.zip
operation=$(jsonGet.py $src_dir/pv${taskID}/info.json Operation)

#------------------------------------------------------------------------------
# Create jobs for submission 
#------------------------------------------------------------------------------
if [ "$operation" -eq "0" ]
then
	# Analyze a single document
	echo "Hello, we are starting to analyze a single file"
	for src_xml in $pv_root/data/src/pv${taskID}/*.xml
	do
		sbatch \
		-p development \
		-t 03:34:56 \
		-n 16 \
		-N 4 \
		-o $pv_root/log/pv${taskID}_%j.out \
		-e $pv_root/log/pv${taskID}_%j.err \
		/opt/apps/perfexpert/3.1/extras/hpctoolkit/bin/hpcrun singleDoc.sh \
		$src_xml \
		$dest_dir \
		rpv${taskID} \
		$taskID
	done 	
else 
	# Compare multiple documents
	echo "Hello, we are starting to compare multiple documents"
	for src_zip in $pv_root/data/src/pv${taskID}/*.zip
	do
		sbatch \
		-p development \
		-t 03:34:56 \
		-n 16 \
		-N 4 \
		-o $pv_root/log/pv${taskID}_%j.out \
		-e $pv_root/log/pv${taskID}_%j.err \
		/opt/apps/perfexpert/3.1/extras/hpctoolkit/bin/hpcrun compare.sh \
		$src_zip \
		$dest_dir \
		rpv${taskID} \
		$src_dir/pv${taskID}/info.json \
		$taskID 
	done
fi
