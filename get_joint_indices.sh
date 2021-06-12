#!/usr/bin/env bash

loc=$(dirname $0)

if [ $# -lt 2 ]; then
    echo "Error: 2 arguments are required.";
    exit 1;
fi

if [ $1 = "1" ]; then
    dir=$(<$loc/conf/task1_raw.conf)
elif [ $1 = "2" ]; then
    dir=$(<$loc/conf/task2_raw.conf)
else
    echo "Error: the first argument should be either \"1\" (for task1) or \"2\" (for task2)."
    exit 1;
fi

file=$loc/$dir/$2
python $loc/utils/transfer.py 1 $file