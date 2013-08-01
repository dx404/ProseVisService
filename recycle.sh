#!/bin/bash
pv_root=$HOME/ProseVisService
src_dir=$pv_root/data/src
dest_dir=$pv_root/data/results
log_dir=$pv_root/log

pv_recycle_root=$HOME/recycleProseVisService
recycle_src_dir=$pv_recycle_root/data/src
recycle_dest_dir=$pv_recycle_root/data/results
recycle_log_dir=$pv_recycle_root/log

mv -f $src_dir/* $recycle_src_dir/ &
mv -f $dest_dir/* $recycle_dest_dir/ &
mv -f $log_dir/* $recycle_log_dir/