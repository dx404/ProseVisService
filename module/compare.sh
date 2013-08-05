#!/bin/bash
#==============================================================================
# 		 FILE: compare.sh
#       USAGE: control.sh <src> <dest> <prefix> <token> <info> <taskID> 
# DESCRIPTION: This is script is for processing the task of comparing multiple 
#              documents. Then entire script is tailored to submit to the 
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
# Enable Profiler
#-------------------------------------------------------------------------------
monitor.sh &

#-------------------------------------------------------------------------------
# Read Command-line arguments and set common parameters
#-------------------------------------------------------------------------------
src_file_zip="$1" # source zip file 
dest_dir="$2"     # destination folder
token_prefix="$3" # unique prefix token
info_file="$4"	  # the info file
taskID="$5"		  # unique task identifier 
meandre_prefix=meandre://seasr.org/services/service-process-zip-tei-xml-through-openmary/instance
mary_host="localhost"
mary_port=59125

#-------------------------------------------------------------------------------
# Extract Corresponding information from the meta json file
#-------------------------------------------------------------------------------
max_phonemes_per_vol=999999999
use_sampling=False
comparison_range=$(jsonGet.py $info_file comparison_range)
num_rounds=$(jsonGet.py $info_file num_rounds)
weighting_power=$(jsonGet.py $info_file weighting_power)
phonemes_window_size=$(jsonGet.py $info_file phonemes_window_size)
pos_weight=$(jsonGet.py $info_file pos_weight)
accent_weight=$(jsonGet.py $info_file accent_weight)
stress_weight=$(jsonGet.py $info_file stress_weight)
tone_weight=$(jsonGet.py $info_file tone_weight)
phraseId_weight=$(jsonGet.py $info_file phraseId_weight)
breakIndex_weight=$(jsonGet.py $info_file breakIndex_weight)
phonemeId_weight=$(jsonGet.py $info_file phonemeId_weight)

#-------------------------------------------------------------------------------
# Invoke Meandre flow Processing
#-------------------------------------------------------------------------------
java -Xms256m -Xmx4g -jar zzre-1.4.12.jar \
Service_Process_ZIP_TEI_XML_through_OpenMary.mau  \
--port "10001" \
--param zip_url="$src_file_zip" \
--param token="$token_prefix"  \
--param $meandre_prefix/push-text/1#message="xsl/add-seasr-id.xsl" \
--param $meandre_prefix/push-text/6#message="xsl/lg-to-p.xsl" \
--param $meandre_prefix/push-text/13#message="xsl/tei-to-document-idonly-concatlg.xsl" \
--param $meandre_prefix/push-text/19#message="xsl/mary-to-csv.xsl" \
--param $meandre_prefix/openmary-client/31#server_hostname="$mary_host" \
--param $meandre_prefix/openmary-client/31#server_port="$mary_port" \
--param $meandre_prefix/write-to-archive/0#default_folder="$dest_dir"  \
--param $meandre_prefix/prosody-similarity/11#comparison_range="$comparison_range"  \
--param $meandre_prefix/prosody-similarity/11#max_phonemes_per_vol="$max_phonemes_per_vol"  \
--param $meandre_prefix/prosody-similarity/11#num_rounds="$num_rounds"  \
--param $meandre_prefix/prosody-similarity/11#use_sampling="$use_sampling"  \
--param $meandre_prefix/prosody-similarity/11#weighting_power="$weighting_power"  \
--param $meandre_prefix/prosody-similarity/11#phonemes_window_size="$phonemes_window_size"  \
--param $meandre_prefix/prosody-similarity/11#pos_weight="$pos_weight"  \
--param $meandre_prefix/prosody-similarity/11#accent_weight="$accent_weight"  \
--param $meandre_prefix/prosody-similarity/11#stress_weight="$stress_weight"  \
--param $meandre_prefix/prosody-similarity/11#tone_weight="$tone_weight"  \
--param $meandre_prefix/prosody-similarity/11#phraseId_weight="$phraseId_weight"  \
--param $meandre_prefix/prosody-similarity/11#phonemeId_weight="$phonemeId_weight"  \
--param $meandre_prefix/prosody-similarity/11#breakIndex_weight="$breakIndex_weight"  

#-------------------------------------------------------------------------------
# Close Open-Mary Service and Make Clean-ups
#-------------------------------------------------------------------------------
mary-close.sh
for result_zip in $dest_dir/rpv${taskID}*
do 
	mv $result_zip $dest_dir/rpv${taskID}.zip
done
