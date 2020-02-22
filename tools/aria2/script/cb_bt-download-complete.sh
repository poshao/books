#!/bin/sh
ARIA2_DWCDIR=/home/shaozi/download/complete

gid=$1
file_count=$2
file_path=$3
file_name=$(basename $file_path)

mv $file_path ${ARIA2_DWCDIR}/$file_name
rm $file_path.aria2
