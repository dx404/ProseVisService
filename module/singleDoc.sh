#!/bin/bash
#==============================================================================
# 		 FILE: singleDoc.sh
#       USAGE: control.sh <src_xml> <dest_dir> <prefix> <token> <taskID> 
# DESCRIPTION: This is script is for processing the task of analyzing a single 
#              document. Then entire script is tailored to submit to the 
#              Stampede Computing Nodes. 
#
#      AUTHOR: Duo Zhao             (UNC Chapel Hill)
#          PI: Tanya Clement        (UT Austin)
#     CREATED: 08.02.2013
#
#==============================================================================

#-------------------------------------------------------------------------------
# start OpenMary Service
#-------------------------------------------------------------------------------
marytts-server.sh &
sleep 10

#-------------------------------------------------------------------------------
# Read Command-line arguments and set common parameters
#-------------------------------------------------------------------------------
src_file_xml="$1" # $1 as source xml file 
dest_dir="$2"     # $2 as destination folder
token_prefix="$3"          # $3 as the prefix token
taskID="$4"          # $3 as the prefix token
meandre_prefix=meandre://seasr.org/services/service-process-tei-xml-through-openmary/instance


#-------------------------------------------------------------------------------
# Invoke Meandre flow Processing
#-------------------------------------------------------------------------------
java -Xmx4g -jar zzre-1.4.12.jar \
Service_Process_TEI_XML_through_OpenMary.mau \
--port "10000" \
--param tei_url="$src_file_xml" \
--param token="$token_prefix" \
--param $meandre_prefix/push-text/1#message="xsl/add-seasr-id.xsl" \
--param $meandre_prefix/push-text/6#message="xsl/lg-to-p.xsl" \
--param $meandre_prefix/push-text/13#message="xsl/tei-to-document-idonly-concatlg.xsl" \
--param $meandre_prefix/push-text/19#message="xsl/mary-to-csv.xsl" \
--param $meandre_prefix/openmary-client/31#server_hostname="localhost" \
--param $meandre_prefix/openmary-client/31#server_port="59125" \
--param $meandre_prefix/write-to-archive/0#default_folder="$dest_dir"


#-------------------------------------------------------------------------------
# Close Open-Mary Service and Make Clean-ups
#-------------------------------------------------------------------------------
mary-close.sh
for result_zip in $dest_dir/rpv${taskID}*
do 
	mv $result_zip $dest_dir/rpv${taskID}.zip
done