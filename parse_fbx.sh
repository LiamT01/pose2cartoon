#!/usr/bin/env bash

loc=$(dirname $0)

if [ $# -lt 1 ]; then
    echo "Error: 1 argument is required.";
    exit 1;
fi

mayapy $loc/utils/fbx_parser.py $1