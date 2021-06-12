#!/bin/bash

loc=$(dirname $0)

if [ $# -lt 1 ]; then
    echo "Error: at least 1 argument is required.";
    exit 1;
fi

num=$#
online="false"
if [ num -eq 2 ]; then
    if [ $2 = "true" ]; then online="true"; fi
fi

seq=$loc/$(<$loc/conf/human_obj.conf)

python utils/vis.py $1 $online $seq;
python utils/pic_to_video.py $1;