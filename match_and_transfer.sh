#!/usr/bin/env bash

loc=$(dirname $0)

if [ $# -lt 3 ]; then
    echo "Error: at least 3 arguments are required.";
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
mapping=$3
seq=$loc/$(<$loc/conf/target_sequence.conf)
online=false;
if [ $# -eq 4 ]; then online=$4; else online="false"; fi

python $loc/utils/transfer.py 2 $file $mapping $seq $online